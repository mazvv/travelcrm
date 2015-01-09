# -*coding: utf-8-*-

from collections import Iterable

from sqlalchemy import func

from . import ResourcesQueryBuilder

from ...models.resource import Resource
from ...models.crosspayment import Crosspayment
from ...models.transfer import Transfer

from ...lib.bl.transfers import query_transfers


class CrosspaymentsQueryBuilder(ResourcesQueryBuilder):
    _subq = query_transfers().subquery()
    _fields = {
        'id': Crosspayment.id,
        '_id': Crosspayment.id,
        'date': _subq.c.date,
        'from': func.coalesce(
            _subq.c.account_from, _subq.c.subaccount_from
        ).label('from'),
        'to': func.coalesce(
            _subq.c.account_to, _subq.c.subaccount_to
        ).label('to'),
        'account_item': _subq.c.account_item,
        'sum': _subq.c.sum,
        'currency': _subq.c.currency,
    }
    _simple_search_fields = [
        _subq.c.account_from,
        _subq.c.account_to,
        _subq.c.subaccount_from,
        _subq.c.subaccount_to,
    ]

    def __init__(self, context):
        super(CrosspaymentsQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = (
            self.query
            .join(Crosspayment, Resource.crosspayment)
            .join(Transfer, Crosspayment.transfer)
            .join(self._subq, Transfer.id == self._subq.c.id)
        )
        self.query = self.query.add_columns(*fields)

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Crosspayment.id.in_(id))

    def advanced_search(self, **kwargs):
        super(CrosspaymentsQueryBuilder, self).advanced_search(**kwargs)
        if 'account_from_id' in kwargs:
            self._filter_account_from(kwargs.get('account_from_id'))
        if 'subaccount_from_id' in kwargs:
            self._filter_subaccount_from(kwargs.get('subaccount_from_id'))
        if 'account_to_id' in kwargs:
            self._filter_account_to(kwargs.get('account_to_id'))
        if 'subaccount_to_id' in kwargs:
            self._filter_subaccount_to(kwargs.get('subaccount_to_id'))
        if 'account_item_id' in kwargs:
            self._filter_account_item(kwargs.get('account_item_id'))
        if 'sum_from' in kwargs or 'sum_to' in kwargs:
            self._filter_sum(
                kwargs.get('sum_from'), kwargs.get('sum_to')
            )
        if 'date_from' in kwargs or 'date_to' in kwargs:
            self._filter_transfer_date(
                kwargs.get('date_from'), kwargs.get('date_to')
            )

    def _filter_account_from(self, account_from_id):
        if account_from_id:
            self.query = self.query.filter(
                Transfer.account_from_id == account_from_id,
            )

    def _filter_subaccount_from(self, subaccount_from_id):
        if subaccount_from_id:
            self.query = self.query.filter(
                Transfer.subaccount_from_id == subaccount_from_id,
            )

    def _filter_account_to(self, account_to_id):
        if account_to_id:
            self.query = self.query.filter(
                Transfer.account_to_id == account_to_id,
            )

    def _filter_subaccount_to(self, subaccount_to_id):
        if subaccount_to_id:
            self.query = self.query.filter(
                Transfer.subaccount_to_id == subaccount_to_id,
            )

    def _filter_account_item(self, account_item_id):
        if account_item_id:
            self.query = self.query.filter(
                Transfer.account_item_id == account_item_id,
            )

    def _filter_sum(self, sum_from, sum_to):
        if sum_from:
            self.query = (
                self.query.filter(Transfer.sum >= sum_from)
            )
        if sum_to:
            self.query = (
                self.query.filter(Transfer.sum <= sum_to)
            )

    def _filter_transfer_date(self, date_from, date_to):
        if date_from:
            self.query = self.query.filter(
                Transfer.date >= date_from
            )
        if date_to:
            self.query = self.query.filter(
                Transfer.date <= date_to
            )
