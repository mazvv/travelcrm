# -*coding: utf-8-*-

from sqlalchemy import func, or_

from . import GeneralQueryBuilder
from ...models import DBSession

from ...lib.bl.cashflows import query_cashflows


class CashflowsQueryBuilder(GeneralQueryBuilder):

    def __init__(self):
        self._subq  = query_cashflows().subquery()
        self._fields = {
            'id': self._subq.c.id,
            '_id': self._subq.c.id,
            'date': self._subq.c.date,
            'account_from_id': self._subq.c.account_from_id,
            'subaccount_from_id': self._subq.c.subaccount_from_id,
            'account_to_id': self._subq.c.account_to_id,
            'subaccount_to_id': self._subq.c.subaccount_to_id,
            'from': func.coalesce(
                self._subq.c.account_from, self._subq.c.subaccount_from, ''
            ).label('from'),
            'to': func.coalesce(
                self._subq.c.account_to, self._subq.c.subaccount_to, ''
            ).label('to'),
            'currency': self._subq.c.currency,
            'account_item': self._subq.c.account_item,
            'sum': self._subq.c.sum.label('sum'),
        }
        self.build_query()

    def build_query(self):
        self.query = DBSession.query(self._subq)
        super(CashflowsQueryBuilder, self).build_query()

    def advanced_search(self, **kwargs):
        if 'account_id' in kwargs:
            self._filter_account(kwargs.get('account_id'))
        if 'subaccount_id' in kwargs:
            self._filter_subaccount(kwargs.get('subaccount_id'))
        if 'date_from' in kwargs or 'date_to' in kwargs:
            self._filter_date(
                kwargs.get('date_from'), kwargs.get('date_to')
            )

    def _filter_account(self, account_id):
        if account_id:
            self.query = self.query.filter(
                or_(
                    self._subq.c.account_from_id == account_id,
                    self._subq.c.account_to_id == account_id,
                    self._subq.c.subaccount_from_account_id == account_id,
                    self._subq.c.subaccount_to_account_id == account_id,
                )
            )

    def _filter_subaccount(self, subaccount_id):
        if subaccount_id:
            self.query = self.query.filter(
                or_(
                    self._subq.c.subaccount_from_id == subaccount_id,
                    self._subq.c.subaccount_to_id == subaccount_id,
                )
            )

    def _filter_date(self, date_from, date_to):
        if date_from:
            self.query = self.query.filter(
                self._subq.c.date >= date_from
            )
        if date_to:
            self.query = self.query.filter(
                self._subq.c.date <= date_to
            )
