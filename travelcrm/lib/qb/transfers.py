# -*coding: utf-8-*-

from sqlalchemy import func, or_

from . import GeneralQueryBuilder
from ...models import DBSession

from ...lib.bl.transfers import query_transfers
from ...lib.utils.common_utils import money_cast, parse_date


class TransfersQueryBuilder(GeneralQueryBuilder):
    _subq  = query_transfers().subquery()
    _fields = {
        'id': _subq.c.id,
        '_id': _subq.c.id,
        'date': _subq.c.date,
        'account_from_id': _subq.c.account_from_id,
        'subaccount_from_id': _subq.c.subaccount_from_id,
        'account_to_id': _subq.c.account_to_id,
        'subaccount_to_id': _subq.c.subaccount_to_id,
        'from': func.coalesce(
            _subq.c.account_from, _subq.c.subaccount_from, ''
        ).label('from'),
        'to': func.coalesce(
            _subq.c.account_to, _subq.c.subaccount_to, ''
        ).label('to'),
        'currency': _subq.c.currency,
        'account_item': _subq.c.account_item,
        'sum': money_cast(_subq.c.sum).label('sum'),
    }

    def __init__(self):
        fields = GeneralQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = DBSession.query(*fields)

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
                self._subq.c.date >= parse_date(date_from)
            )
        if date_to:
            self.query = self.query.filter(
                self._subq.c.date <= parse_date(date_to)
            )
