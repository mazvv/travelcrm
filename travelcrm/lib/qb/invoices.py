# -*coding: utf-8-*-
from collections import Iterable

from sqlalchemy import func

from . import ResourcesQueryBuilder
from ...models import DBSession
from ...models.resource import Resource
from ...models.invoice import Invoice
from ...models.account import Account
from ...models.currency import Currency
from ...models.resource_type import ResourceType
from ...models.income import Income
from ...models.fin_transaction import FinTransaction

from ...lib.bl.invoices import query_resource_data
from ...lib.bl.currencies_rates import query_convert_rates
from ...lib.utils.common_utils import money_cast


class InvoicesQueryBuilder(ResourcesQueryBuilder):
    _subq_resource_type = (
        DBSession.query(ResourceType.humanize, Resource.id)
        .join(Resource, ResourceType.resources)
        .subquery()
    )

    _subq_resource_data = query_resource_data().subquery()
    _subq_rate = (
        query_convert_rates(
            Account.currency_id,
            Invoice.date
        )
        .as_scalar()
    )
    _subq_invoice_sum = money_cast(
        func.coalesce(
            _subq_resource_data.c.sum / _subq_rate,
            _subq_resource_data.c.sum
        )
    )
    _sum_payments = (
        DBSession.query(
            func.sum(FinTransaction.sum).label('sum'), Income.invoice_id
        )
        .join(Income, FinTransaction.income)
        .group_by(Income.invoice_id)
        .subquery()
    )

    _fields = {
        'id': Invoice.id,
        '_id': Invoice.id,
        'date': Invoice.date,
        'account': Account.name,
        'account_type': Account.account_type,
        'sum': _subq_invoice_sum.label('sum'),
        'payments': func.coalesce(_sum_payments.c.sum, 0),
        'payments_percent': func.round(
            100 * func.coalesce(_sum_payments.c.sum, 0) / _subq_invoice_sum,
            2
        ),
        'resource_type': _subq_resource_type.c.humanize,
        'customer': _subq_resource_data.c.customer,
        'currency': Currency.iso_code,
    }
    _simple_search_fields = [
        Account.name,
        _subq_resource_data.c.customer,
        _subq_resource_type.c.humanize,
    ]

    def __init__(self, context):
        super(InvoicesQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = (
            self.query
            .join(Invoice, Resource.invoice)
            .join(Account, Invoice.account)
            .join(Currency, Account.currency)
            .join(
                self._subq_resource_data,
                self._subq_resource_data.c.invoice_id
                == Invoice.id
            )
            .join(
                self._subq_resource_type,
                self._subq_resource_type.c.id
                == self._subq_resource_data.c.resource_id
            )
            .outerjoin(
                self._sum_payments,
                self._sum_payments.c.invoice_id
                == Invoice.id
            )
        )

        self.query = self.query.add_columns(*fields)

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Invoice.id.in_(id))
