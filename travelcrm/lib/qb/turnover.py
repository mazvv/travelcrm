# -*coding: utf-8-*-

from sqlalchemy import func

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.account import Account
from ...models.subaccount import Subaccount
from ...models.currency import Currency
from ...lib.bl.turnovers import (
    query_accounts_turnovers,
    query_subaccounts_turnovers,
)


class TurnoverAccountQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(TurnoverAccountQueryBuilder, self).__init__(context)
        self._subq = query_accounts_turnovers().subquery()
        self._fields = {
            'id': self._subq.c.id,
            '_id': self._subq.c.id,
            'name': Account.name,
            'currency': Currency.iso_code,
            'sum_from': func.coalesce(self._subq.c.sum_from, 0),
            'sum_to': func.coalesce(self._subq.c.sum_to, 0),
            'balance': (
                func.coalesce(self._subq.c.sum_to, 0) 
                - func.coalesce(self._subq.c.sum_from, 0)
            ),
        }
        self._simple_search_fields = [
            Account.name,
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = (
            self.query.join(Account, Resource.account)
            .join(self._subq, Account.id == self._subq.c.id)
            .join(Currency, Account.currency)
        )
        super(TurnoverAccountQueryBuilder, self).build_query()

    def advanced_search(self, **kwargs):
        if 'date_from' in kwargs or 'date_to' in kwargs:
            self._filter_date(
                kwargs.get('date_from'), kwargs.get('date_to')
            )
        if 'currency_id' in kwargs:
            self._filter_currency(kwargs.get('currency_id'))

    def _filter_date(self, date_from, date_to):
        self._sabq = query_accounts_turnovers(date_from, date_to).subquery()
    
    def _filter_currency(self, currency_id):
        if currency_id:
            self.query = self.query.filter(Currency.id == currency_id)


class TurnoverSubaccountQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(TurnoverSubaccountQueryBuilder, self).__init__(context)
        self._subq = query_subaccounts_turnovers().subquery()
        self._fields = {
            'id': self._subq.c.id,
            '_id': self._subq.c.id,
            'name': Subaccount.name,
            'currency': Currency.iso_code,
            'sum_from': func.coalesce(self._subq.c.sum_from, 0),
            'sum_to': func.coalesce(self._subq.c.sum_to, 0),
            'balance': (
                func.coalesce(self._subq.c.sum_to, 0) 
                - func.coalesce(self._subq.c.sum_from, 0)
            ),
        }
        self._simple_search_fields = [
            Subaccount.name,
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = (
            self.query.join(Subaccount, Resource.subaccount)
            .join(self._subq, Subaccount.id == self._subq.c.id)
            .join(Account, Subaccount.account)
            .join(Currency, Account.currency)
        )
        super(TurnoverSubaccountQueryBuilder, self).build_query()

    def advanced_search(self, **kwargs):
        if 'date_from' in kwargs or 'date_to' in kwargs:
            self._filter_date(
                kwargs.get('date_from'), kwargs.get('date_to')
            )
        if 'currency_id' in kwargs:
            self._filter_currency(kwargs.get('currency_id'))

    def _filter_date(self, date_from, date_to):
        self._sabq = query_subaccounts_turnovers(date_from, date_to).subquery()
    
    def _filter_currency(self, currency_id):
        if currency_id:
            self.query = self.query.filter(Currency.id == currency_id)
