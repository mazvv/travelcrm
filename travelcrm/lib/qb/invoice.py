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
from ...models.cashflow import Cashflow

from ...lib.bl.invoices import query_resource_data
from ...lib.bl.currencies_rates import query_convert_rates


class InvoiceQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(InvoiceQueryBuilder, self).__init__(context)
        self._subq_resource_type = (
            DBSession.query(ResourceType.humanize, Resource.id)
            .join(Resource, ResourceType.resources)
            .subquery()
        )
        self._subq_resource_data = query_resource_data().subquery()
        subq_rate = (
            query_convert_rates(
                Account.currency_id,
                Invoice.date
            )
            .as_scalar()
        )
        self._subq_invoice_sum = func.coalesce(
            self._subq_resource_data.c.sum / subq_rate,
            self._subq_resource_data.c.sum
        )
        self._sum_payments = (
            DBSession.query(
                func.sum(Cashflow.sum).label('sum'), 
                Income.invoice_id
            )
            .join(Income, Cashflow.income)
            .filter(
                Cashflow.account_from_id == None,
                Cashflow.subaccount_from_id == None,
            )
            .group_by(Income.invoice_id)
            .subquery()
        )
        self._fields = {
            'id': Invoice.id,
            '_id': Invoice.id,
            'date': Invoice.date,
            'active_until': Invoice.active_until,
            'account': Account.name,
            'account_type': Account.account_type,
            'sum': self._subq_invoice_sum.label('sum'),
            'payments': func.coalesce(self._sum_payments.c.sum, 0),
            'payments_percent': func.round(
                100 * func.coalesce(self._sum_payments.c.sum, 0) 
                / self._subq_invoice_sum,
                2
            ),
            'resource_type': self._subq_resource_type.c.humanize,
            'customer': self._subq_resource_data.c.customer,
            'currency': Currency.iso_code,
        }
        self._simple_search_fields = [
            Account.name,
            self._subq_resource_data.c.customer,
            self._subq_resource_type.c.humanize,
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
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
        super(InvoiceQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Invoice.id.in_(id))

    def advanced_search(self, **kwargs):
        super(InvoiceQueryBuilder, self).advanced_search(**kwargs)
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
                Invoice.date >= date_from
            )
        if date_to:
            self.query = self.query.filter(
                Invoice.date <= date_to
            )
