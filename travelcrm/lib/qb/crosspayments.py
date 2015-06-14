# -*coding: utf-8-*-

from collections import Iterable

from . import ResourcesQueryBuilder

from ...models.resource import Resource
from ...models.crosspayment import Crosspayment
from ...models.cashflow import Cashflow
from ...lib.bl.cashflows import query_cashflows


class CrosspaymentsQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(CrosspaymentsQueryBuilder, self).__init__(context)
        self._subq = query_cashflows().subquery()
        self._fields = {
            'id': Crosspayment.id,
            '_id': Crosspayment.id,
            'date': Cashflow.date,
            'subaccount_from': (
                self._subq.c.subaccount_from.label('subaccount_from')
            ),
            'subaccount_to': (
                self._subq.c.subaccount_to.label('subaccount_to')
            ),
            'account_from': (
                self._subq.c.account_from.label('account_from')
            ),
            'account_to': (
                self._subq.c.account_to.label('account_to')
            ),
            'account_item': (
                self._subq.c.account_item.label('account_item')
            ),
            'sum': Cashflow.sum,
            'currency': self._subq.c.currency.label('currency'),
        }
        self._simple_search_fields = [
            self._subq.c.subaccount_from,
            self._subq.c.subaccount_to,
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = (
            self.query
            .join(Crosspayment, Resource.crosspayment)
            .join(Cashflow, Crosspayment.cashflow)
            .join(self._subq, Cashflow.id == self._subq.c.id)
        )
        super(CrosspaymentsQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Crosspayment.id.in_(id))

    def advanced_search(self, **kwargs):
        super(CrosspaymentsQueryBuilder, self).advanced_search(**kwargs)
        if 'subaccount_from_id' in kwargs:
            self._filter_subaccount_from(kwargs.get('subaccount_from_id'))
        if 'subaccount_to_id' in kwargs:
            self._filter_subaccount_to(kwargs.get('subaccount_to_id'))
        if 'account_item_id' in kwargs:
            self._filter_account_item(kwargs.get('account_item_id'))
        if 'sum_from' in kwargs or 'sum_to' in kwargs:
            self._filter_sum(
                kwargs.get('sum_from'), kwargs.get('sum_to')
            )
        if 'date_from' in kwargs or 'date_to' in kwargs:
            self._filter_cashflow_date(
                kwargs.get('date_from'), kwargs.get('date_to')
            )

    def _filter_subaccount_from(self, subaccount_from_id):
        if subaccount_from_id:
            self.query = self.query.filter(
                Cashflow.subaccount_from_id == subaccount_from_id,
            )

    def _filter_subaccount_to(self, subaccount_to_id):
        if subaccount_to_id:
            self.query = self.query.filter(
                Cashflow.subaccount_to_id == subaccount_to_id,
            )

    def _filter_account_item(self, account_item_id):
        if account_item_id:
            self.query = self.query.filter(
                Cashflow.account_item_id == account_item_id,
            )

    def _filter_sum(self, sum_from, sum_to):
        if sum_from:
            self.query = (
                self.query.filter(Cashflow.sum >= sum_from)
            )
        if sum_to:
            self.query = (
                self.query.filter(Cashflow.sum <= sum_to)
            )

    def _filter_cashflow_date(self, date_from, date_to):
        if date_from:
            self.query = self.query.filter(
                Cashflow.date >= date_from
            )
        if date_to:
            self.query = self.query.filter(
                Cashflow.date <= date_to
            )
