# -*coding: utf-8-*-
from collections import Iterable

from sqlalchemy import func

from . import ResourcesQueryBuilder
from ...models import DBSession
from ...models.resource import Resource
from ...models.resource_type import ResourceType
from ...models.refund import Refund
from ...models.invoice import Invoice
from ...models.account import Account
from ...models.currency import Currency
from ...models.fin_transaction import FinTransaction

from ...lib.bl.invoices import query_resource_data
from ...lib.utils.common_utils import parse_date


class RefundsQueryBuilder(ResourcesQueryBuilder):

    _fields = {
        'id': Refund.id,
        '_id': Refund.id,
        'invoice_id': Refund.invoice_id,
    }
    _simple_search_fields = [

    ]

    def __init__(self, context):
        super(RefundsQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = (
            self.query
            .join(Refund, Resource.refund)
            .outerjoin(Invoice, Refund.invoice)
        )
        self.query = self.query.add_columns(*fields)

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Refund.id.in_(id))

    def advanced_search(self, **kwargs):
        super(RefundsQueryBuilder, self).advanced_search(**kwargs)
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
