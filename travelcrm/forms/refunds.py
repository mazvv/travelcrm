# -*-coding: utf-8 -*-

import colander
from babel.dates import parse_date

from . import ResourceSchema, Date

from ..models.invoice import Invoice
from ..lib.bl.accounts import get_account_balance
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
        date = parse_date(date, locale=get_locale_name())
        invoice = Invoice.get(invoice_id)
        if not invoice:
            return
        account_balance = get_account_balance(
            invoice.account_id, None, date
        )
        if account_balance <= value:
            raise colander.Invalid(
                node,
                _(u'Account Balance is not enough for refund'),
            )
    return colander.All(validator,)


class RefundSchema(ResourceSchema):
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


class SettingsSchema(colander.Schema):
    account_item_id = colander.SchemaNode(
        colander.Integer()
    )
