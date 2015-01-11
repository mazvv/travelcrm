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
from ...lib.utils.common_utils import cast_int


class TurnoversAccountsQueryBuilder(ResourcesQueryBuilder):
    _subq = query_accounts_turnovers().subquery()
    _fields = {
        'id': _subq.c.id,
        '_id': _subq.c.id,
        'name': Account.name,
        'currency': Currency.iso_code,
        'sum_from': func.coalesce(_subq.c.sum_from, 0),
        'sum_to': func.coalesce(_subq.c.sum_to, 0),
        'balance': (
            func.coalesce(_subq.c.sum_to, 0) 
            - func.coalesce(_subq.c.sum_from, 0)
        ),
    }
    _simple_search_fields = [
        Account.name,
    ]

    def __init__(self, context):
        super(TurnoversAccountsQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = (
            self.query.join(Account, Resource.account)
            .join(self._subq, Account.id == self._subq.c.id)
            .join(Currency, Account.currency)
        )
        self.query = self.query.add_columns(*fields)
        

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


class TurnoversSubaccountsQueryBuilder(ResourcesQueryBuilder):
    _subq = query_subaccounts_turnovers().subquery()
    _fields = {
        'id': _subq.c.id,
        '_id': _subq.c.id,
        'name': Subaccount.name,
        'currency': Currency.iso_code,
        'sum_from': func.coalesce(_subq.c.sum_from, 0),
        'sum_to': func.coalesce(_subq.c.sum_to, 0),
        'balance': (
            func.coalesce(_subq.c.sum_to, 0) 
            - func.coalesce(_subq.c.sum_from, 0)
        ),
    }
    _simple_search_fields = [
        Subaccount.name,
    ]

    def __init__(self, context):
        super(TurnoversSubaccountsQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = (
            self.query.join(Subaccount, Resource.subaccount)
            .join(self._subq, Subaccount.id == self._subq.c.id)
            .join(Account, Subaccount.account)
            .join(Currency, Account.currency)
        )
        self.query = self.query.add_columns(*fields)

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
