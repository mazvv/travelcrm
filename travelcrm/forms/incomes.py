# -*-coding: utf-8 -*-

from decimal import Decimal

import colander
from babel.dates import parse_date

from . import ResourceSchema, Date

from ..models.invoice import Invoice
from ..lib.bl.invoices import (
    get_factory_by_invoice_id,
    get_bound_resource_by_invoice_id
)
from ..lib.bl.invoices import query_invoice_payments
from ..lib.bl.currencies_rates import query_convert_rates
from ..lib.utils.common_utils import get_locale_name, translate as _


@colander.deferred
def sum_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        if value <= 0:
            raise colander.Invalid(
                node,
                _(u'Sum must be more then zero'),
            )
        invoice_id = request.params.get('invoice_id')
        date = request.params.get('date')
        invoice = Invoice.get(invoice_id)
        if not date or not invoice:
            return

        date = parse_date(date, locale=get_locale_name())
        factory = get_factory_by_invoice_id(invoice.id)
        rate = query_convert_rates(invoice.account.currency.id, date).scalar()
        if not rate:
            rate = 1
        resource = get_bound_resource_by_invoice_id(invoice.id)
        base_sum = factory.get_base_sum(resource.id)
        payments = query_invoice_payments(invoice.id)
        payed_sum = sum(payment.sum for payment in payments)
        max_sum = (
            Decimal((base_sum - payed_sum) / rate).quantize(Decimal('.01'))
        )
        if max_sum == 0:
            raise colander.Invalid(
                node,
                _(u'Selected invice is fully payed'),
            )
        elif max_sum < Decimal(request.params.get('sum')):
            raise colander.Invalid(
                node,
                _(u'Sum must be %s or less') % max_sum,
            )
    return colander.All(validator,)


class IncomeSchema(ResourceSchema):
    invoice_id = colander.SchemaNode(
        colander.Integer(),
    )
    date = colander.SchemaNode(
        Date(),
    )
    sum = colander.SchemaNode(
        colander.Money(),
        validator=sum_validator
    )


class IncomeCurrencySchema(ResourceSchema):
    invoice_id = colander.SchemaNode(
        colander.Integer(),
    )
