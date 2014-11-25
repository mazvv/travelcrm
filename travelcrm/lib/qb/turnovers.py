# -*coding: utf-8-*-

from sqlalchemy import func

from . import GeneralQueryBuilder
from ...models import DBSession
from ...models.account import Account
from ...models.subaccount import Subaccount
from ...models.currency import Currency

from ...lib.bl.turnovers import (
    query_accounts_turnovers,
    query_subaccounts_turnovers,
)
from ...lib.utils.common_utils import money_cast


class TurnoversAccountsQueryBuilder(GeneralQueryBuilder):
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

    def __init__(self):
        fields = GeneralQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = (
            DBSession.query(*fields)
            .select_from(Account)
            .join(self._subq, Account.id == self._subq.c.id)
            .join(Currency, Account.currency)
        )

    def advanced_search(self, **kwargs):
        if 'date_from' in kwargs or 'date_to' in kwargs:
            self._filter_date(
                kwargs.get('date_from'), kwargs.get('date_to')
            )


class TurnoversSubaccountsQueryBuilder(GeneralQueryBuilder):
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

    def __init__(self):
        fields = GeneralQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = (
            DBSession.query(*fields)
            .select_from(Subaccount)
            .join(self._subq, Subaccount.id == self._subq.c.id)
            .join(Account, Subaccount.account)
            .join(Currency, Account.currency)
        )

    def advanced_search(self, **kwargs):
        if 'date_from' in kwargs or 'date_to' in kwargs:
            self._filter_date(
                kwargs.get('date_from'), kwargs.get('date_to')
            )
