# -*coding: utf-8-*-
from collections import Iterable

from sqlalchemy import func

from . import ResourcesQueryBuilder
from ...models import DBSession
from ...models.resource import Resource
from ...models.resource_type import ResourceType
from ...models.income import Income
from ...models.invoice import Invoice
from ...models.account import Account
from ...models.currency import Currency
from ...models.fin_transaction import FinTransaction

from ...lib.bl.invoices import query_resource_data
from ...lib.utils.common_utils import parse_date


class IncomesQueryBuilder(ResourcesQueryBuilder):

    _subq_invoice_resource_data = query_resource_data().subquery()
    _subq_resource_type = (
        DBSession.query(ResourceType.humanize, Resource.id)
        .join(Resource, ResourceType.resources)
        .subquery()
    )
    _sum_subq = (
        DBSession.query(
            func.sum(FinTransaction.sum).label('sum'),
            Income.id,
            FinTransaction.date,
        )
        .join(Income, FinTransaction.income)
        .group_by(Income.id, FinTransaction.date)
        .subquery()
    )

    _fields = {
        'id': Income.id,
        '_id': Income.id,
        'invoice_id': Income.invoice_id,
        'date': _sum_subq.c.date,
        'customer': _subq_invoice_resource_data.c.customer,
        'resource_type': _subq_resource_type.c.humanize,
        'currency': Currency.iso_code,
        'sum': _sum_subq.c.sum,
        'account_name': Account.name,
        'account_type': Account.account_type
    }
    _simple_search_fields = [
        _subq_invoice_resource_data.c.customer,
    ]

    def __init__(self, context):
        super(IncomesQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = (
            self.query
            .join(Income, Resource.income)
            .join(Invoice, Income.invoice)
            .join(Account, Invoice.account)
            .join(Currency, Account.currency)
            .join(
                self._subq_invoice_resource_data,
                self._subq_invoice_resource_data.c.invoice_id
                == Invoice.id
            )
            .join(
                self._subq_resource_type,
                self._subq_resource_type.c.id
                == self._subq_invoice_resource_data.c.resource_id
            )
            .join(self._sum_subq, self._sum_subq.c.id == Income.id)
        )
        self.query = self.query.add_columns(*fields)

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Income.id.in_(id))

    def advanced_search(self, **kwargs):
        super(IncomesQueryBuilder, self).advanced_search(**kwargs)
        if 'invoice_id' in kwargs:
            self._filter_invoice(kwargs.get('invoice_id'))
        if 'account_id' in kwargs:
            self._filter_account(kwargs.get('account_id'))
        if 'currency_id' in kwargs:
            self._filter_currency(kwargs.get('currency_id'))
        if 'sum_from' in kwargs or 'sum_to' in kwargs:
            self._filter_sum(
                kwargs.get('sum_from'), kwargs.get('sum_to')
            )
        if 'payment_from' in kwargs or 'payment_to' in kwargs:
            self._filter_payment_date(
                kwargs.get('payment_from'), kwargs.get('payment_to')
            )

    def _filter_invoice(self, invoice_id):
        if invoice_id:
            self.query = self.query.filter(Invoice.id == invoice_id)

    def _filter_account(self, account_id):
        if account_id:
            self.query = self.query.filter(Account.id == account_id)

    def _filter_currency(self, currency_id):
        if currency_id:
            self.query = self.query.filter(Currency.id == currency_id)

    def _filter_sum(self, sum_from, sum_to):
        if sum_from:
            self.query = self.query.filter(self._sum_subq.c.sum >= sum_from)
        if sum_to:
            self.query = self.query.filter(self._sum_subq.c.sum <= sum_to)

    def _filter_payment_date(self, date_from, date_to):
        if date_from:
            self.query = self.query.filter(
                self._sum_subq.c.date >= parse_date(date_from)
            )
        if date_to:
            self.query = self.query.filter(
                self._sum_subq.c.date <= parse_date(date_to)
            )
