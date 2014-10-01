# -*coding: utf-8-*-
from collections import Iterable

from sqlalchemy import func

from . import ResourcesQueryBuilder

from ...models import DBSession
from ...models.resource import Resource
from ...models.outgoing import Outgoing
from ...models.invoice import Invoice
from ...models.account import Account
from ...models.account_item import AccountItem
from ...models.currency import Currency
from ...models.touroperator import Touroperator
from ...models.fin_transaction import FinTransaction

from ...lib.utils.common_utils import parse_date


class OutgoingsQueryBuilder(ResourcesQueryBuilder):

    _sum_subq = (
        DBSession.query(
            func.sum(FinTransaction.sum).label('sum'),
            Outgoing.id,
            FinTransaction.date,
            AccountItem.id.label('account_item_id'),
            AccountItem.name.label('account_item_name'),
        )
        .join(Outgoing, FinTransaction.outgoing)
        .join(AccountItem, FinTransaction.account_item)
        .group_by(
            Outgoing.id,
            FinTransaction.date,
            AccountItem.name,
            AccountItem.id,
        )
        .subquery()
    )

    _fields = {
        'id': Outgoing.id,
        '_id': Outgoing.id,
        'date': _sum_subq.c.date,
        'sum': _sum_subq.c.sum,
        'account_name': Account.name,
        'account_item': _sum_subq.c.account_item_name,
        'currency': Currency.iso_code,
        'touroperator': Touroperator.name,
    }
    _simple_search_fields = [
        Account.name,
        Touroperator.name,
        _sum_subq.c.account_item_name,
    ]

    def __init__(self, context):
        super(OutgoingsQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = (
            self.query
            .join(Outgoing, Resource.outgoing)
            .join(Account, Outgoing.account)
            .join(Touroperator, Outgoing.touroperator)
            .join(Currency, Account.currency)
            .join(self._sum_subq, self._sum_subq.c.id == Outgoing.id)
        )
        self.query = self.query.add_columns(*fields)

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Outgoing.id.in_(id))

    def advanced_search(self, **kwargs):
        super(OutgoingsQueryBuilder, self).advanced_search(**kwargs)
        if 'account_id' in kwargs:
            self._filter_account(kwargs.get('account_id'))
        if 'account_item_id' in kwargs:
            self._filter_account_item(kwargs.get('account_item_id'))
        if 'touroperator_id' in kwargs:
            self._filter_touroperator(kwargs.get('touroperator_id'))
        if 'currency_id' in kwargs:
            self._filter_currency(kwargs.get('currency_id'))
        if 'sum_from' in kwargs or 'sum_to' in kwargs:
            self._filter_sum(
                kwargs.get('sum_from'), kwargs.get('sum_to')
            )
        if 'payment_from' in kwargs or 'payment_to' in kwargs:
            self._filter_payment_date(
                kwargs.get('payment_from'), kwargs.get('payment_to')
            )

    def _filter_account_item(self, account_item_id):
        if account_item_id:
            self.query = self.query.filter(
                self._sum_subq.c.account_item_id == account_item_id
            )

    def _filter_touroperator(self, touroperator_id):
        if touroperator_id:
            self.query = self.query.filter(Touroperator.id == touroperator_id)

    def _filter_account(self, account_id):
        if account_id:
            self.query = self.query.filter(Account.id == account_id)

    def _filter_currency(self, currency_id):
        if currency_id:
            self.query = self.query.filter(Currency.id == currency_id)

    def _filter_sum(self, sum_from, sum_to):
        if sum_from:
            self.query = self.query.filter(self._sum_subq.c.sum >= sum_from)
        if sum_to:
            self.query = self.query.filter(self._sum_subq.c.sum <= sum_to)

    def _filter_payment_date(self, date_from, date_to):
        if date_from:
            self.query = self.query.filter(
                self._sum_subq.c.date >= parse_date(date_from)
            )
        if date_to:
            self.query = self.query.filter(
                self._sum_subq.c.date <= parse_date(date_to)
            )
