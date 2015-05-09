# -*coding: utf-8-*-

from sqlalchemy import func, and_, or_

from . import ResourcesQueryBuilder
from ...models import DBSession
from ...models.resource import Resource
from ...models.account import Account
from ...models.subaccount import Subaccount
from ...models.calculation import Calculation
from ...models.order_item import OrderItem
from ...models.supplier import Supplier
from ...models.currency import Currency
from ...models.cashflow import Cashflow

from ...lib.bl.calculations import query_resource_data


class DebtQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(DebtQueryBuilder, self).__init__(context)
        self._subq_cashflows = (
            DBSession.query(
                Cashflow.sum,
                Cashflow.date, 
                Supplier.id,
                Account.currency_id.label('currency_id')
            )
            .join(Subaccount, Cashflow.subaccount_from)
            .join(Supplier, Subaccount.supplier)
            .join(Account, Subaccount.account)
            .subquery()
        )
        subq_resource_data = query_resource_data().subquery()
        self._subq_calculations = (
            DBSession.query(
                subq_resource_data.c.date,
                Calculation.price.label('sum'),
                Calculation.currency_id,
                OrderItem.supplier_id,
            )
            .join(OrderItem, Calculation.order_item)
            .join(
                subq_resource_data, 
                OrderItem.id == subq_resource_data.c.service_item_id
            )
            .subquery()
        )
        self._field_sum_in = func.coalesce(
            func.sum(self._subq_cashflows.c.sum), 0
        )
        self._field_sum_out = func.coalesce(
            func.sum(self._subq_calculations.c.sum), 0
        )
        self._fields = {
            'id': Supplier.id,
            '_id': Supplier.id,
            'name': Supplier.name,
            'currency': Currency.iso_code,
            'sum_in': self._field_sum_in,
            'sum_out': self._field_sum_out,
            'balance': (self._field_sum_out - self._field_sum_in)
        }
        self._simple_search_fields = [
            Supplier.name,
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = (
            self.query
            .join(Supplier, Resource.supplier)
            .outerjoin(
                self._subq_calculations, 
                self._subq_calculations.c.supplier_id == Supplier.id,
            )
            .join(
                Currency, self._subq_calculations.c.currency_id == Currency.id
            )
            .outerjoin(
                self._subq_cashflows, 
                and_(
                    self._subq_cashflows.c.id == Supplier.id,
                    self._subq_cashflows.c.currency_id == Currency.id
                )
            )
            .group_by(Supplier.id, Supplier.name, Currency.iso_code)
        )
        super(DebtQueryBuilder, self).build_query()
        self.query = self.query.with_entities(
            Supplier.id, Supplier.name, 
            Currency.iso_code.label('currency'),
            self._field_sum_in.label('sum_in'),
            self._field_sum_out.label('sum_out'),
            (self._field_sum_out - self._field_sum_in).label('balance')
        )

    def advanced_search(self, **kwargs):
        if 'date_from' in kwargs or 'date_to' in kwargs:
            self._filter_date(
                kwargs.get('date_from'), kwargs.get('date_to')
            )
        if 'currency_id' in kwargs:
            self._filter_currency(kwargs.get('currency_id'))

    def _filter_date(self, date_from, date_to):
        if date_from:
            self.query = self.query.filter(
                or_(
                    self._subq_calculations.c.date >= date_from,
                    self._subq_cashflows.c.date >= date_from,
                )
            )
        if date_to:
            self.query = self.query.filter(
                or_(
                    self._subq_calculations.c.date <= date_to,
                    self._subq_cashflows.c.date <= date_to,
                )
            )
    
    def _filter_currency(self, currency_id):
        if currency_id:
            self.query = self.query.filter(
                Currency.id == currency_id
            )
