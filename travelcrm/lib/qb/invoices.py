# -*coding: utf-8-*-
from collections import Iterable

from sqlalchemy import func

from . import ResourcesQueryBuilder
from ...models import DBSession
from ...models.resource import Resource
from ...models.invoice import Invoice
from ...models.invoice_item import InvoiceItem
from ...models.account import Account
from ...models.currency import Currency
from ...models.person import Person
from ...models.order import Order
from ...models.income import Income


class InvoicesQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(InvoicesQueryBuilder, self).__init__(context)
        self._sum_invoice = (
            DBSession.query(
                func.sum(InvoiceItem.final_price).label('final_price'), 
                InvoiceItem.invoice_id.label('invoice_id')
            )
            .group_by(InvoiceItem.invoice_id)
            .subquery()
        )
        self._sum_payments = (
            DBSession.query(
                func.sum(Income.sum).label('payments'),
                Income.invoice_id.label('invoice_id')
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
            'final_price': self._sum_invoice.c.final_price,
            'payments': self._sum_payments.c.payments,
            'debt': (
                self._sum_invoice.c.final_price - self._sum_payments.c.payments
            ),
            'payments_percent': func.coalesce(
                func.round(
                    (self._sum_payments.c.payments * 100) 
                    / self._sum_invoice.c.final_price, 2
                ),
                0
            ),
            'customer': Person.name,
            'currency': Currency.iso_code,
        }
        self._simple_search_fields = [
            Account.name,
            Person.name,
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = (
            self.query
            .join(Invoice, Resource.invoice)
            .join(Order, Invoice.order)
            .join(Account, Invoice.account)
            .join(Currency, Account.currency)
            .join(Person, Order.customer)
            .join(
                self._sum_invoice,
                self._sum_invoice.c.invoice_id == Invoice.id
            )
            .outerjoin(
                self._sum_payments,
                self._sum_payments.c.invoice_id == Invoice.id
            )
        )
        super(InvoicesQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Invoice.id.in_(id))

    def advanced_search(self, **kwargs):
        super(InvoicesQueryBuilder, self).advanced_search(**kwargs)
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
                func.coalesce(self._sum_payments.c.payments, 0) >= payment_from
            )
        if payment_to:
            self.query = self.query.filter(
                func.coalesce(self._sum_payments.c.payments, 0) <= payment_to
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
