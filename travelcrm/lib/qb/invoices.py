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
from ...lib.utils.common_utils import money_cast, parse_date


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

    def advanced_search(self, updated_from, updated_to, modifier_id, **kwargs):
        super(InvoicesQueryBuilder, self).advanced_search(
            updated_from, updated_to, modifier_id
        )
        if 'currency_id' in kwargs:
            self._filter_currency(kwargs.get('currency_id'))
        if 'sum_from' in kwargs or 'sum_to' in kwargs:
            self._filter_sum(
                kwargs.get('sum_from'), kwargs.get('sum_to')
            )
        if 'payment_from' in kwargs or 'payment_to' in kwargs:
            self._filter_payment(
                kwargs.get('payment_from'), kwargs.get('payment_to')
            )
        if 'date_from' in kwargs or 'date_to' in kwargs:
            self._filter_invoice_date(
                kwargs.get('date_from'), kwargs.get('date_to')
            )

    def _filter_currency(self, currency_id):
        if currency_id:
            self.query = self.query.filter(Currency.id == currency_id)

    def _filter_sum(self, sum_from, sum_to):
        if sum_from:
            self.query = self.query.filter(
                self._subq_invoice_sum >= sum_from
            )
        if sum_to:
            self.query = self.query.filter(
                self._subq_invoice_sum <= sum_to
            )

    def _filter_payment(self, payment_from, payment_to):
        if payment_from:
            self.query = self.query.filter(
                func.coalesce(self._sum_payments.c.sum, 0) >= payment_from
            )
        if payment_to:
            self.query = self.query.filter(
                func.coalesce(self._sum_payments.c.sum, 0) <= payment_to
            )

    def _filter_invoice_date(self, date_from, date_to):
        if date_from:
            self.query = self.query.filter(
                Invoice.date >= parse_date(date_from)
            )
        if date_to:
            self.query = self.query.filter(
                Invoice.date <= parse_date(date_to)
            )
