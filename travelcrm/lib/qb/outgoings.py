# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder

from ...models import DBSession
from ...models.resource import Resource
from ...models.resource_type import ResourceType
from ...models.outgoing import Outgoing
from ...models.account import Account
from ...models.subaccount import Subaccount
from ...models.account_item import AccountItem
from ...models.currency import Currency
from ...lib.bl.subaccounts import query_resource_data


class OutgoingsQueryBuilder(ResourcesQueryBuilder):
    _subq_subaccount_type = (
        DBSession.query(ResourceType.humanize, Resource.id)
        .join(Resource, ResourceType.resources)
        .subquery()
    )
    _subq_subaccount_data = query_resource_data().subquery()
    _fields = {
        'id': Outgoing.id,
        '_id': Outgoing.id,
        'date': Outgoing.date,
        'sum': Outgoing.sum,
        'account': Account.name,
        'account_item': AccountItem.name,
        'currency': Currency.iso_code,
        'resource': _subq_subaccount_data.c.title,
        'resource_type': _subq_subaccount_type.c.humanize,
    }
    _simple_search_fields = [
        Account.name,
        _subq_subaccount_data.c.name,
        _subq_subaccount_data.c.title,
    ]

    def __init__(self, context):
        super(OutgoingsQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = (
            self.query
            .join(Outgoing, Resource.outgoing)
            .join(Subaccount, Outgoing.subaccount)
            .join(Account, Subaccount.account)
            .join(Currency, Account.currency)
            .join(AccountItem, Outgoing.account_item)
            .join(
                self._subq_subaccount_data, 
                Outgoing.subaccount_id 
                == self._subq_subaccount_data.c.subaccount_id
            )
            .join(
                self._subq_subaccount_type,
                self._subq_subaccount_type.c.id
                == self._subq_subaccount_data.c.resource_id
            )
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
                AccountItem.id == account_item_id
            )

    def _filter_account(self, account_id):
        if account_id:
            self.query = self.query.filter(Account.id == account_id)

    def _filter_currency(self, currency_id):
        if currency_id:
            self.query = self.query.filter(Currency.id == currency_id)

    def _filter_sum(self, sum_from, sum_to):
        if sum_from:
            self.query = self.query.filter(Outgoing.sum >= sum_from)
        if sum_to:
            self.query = self.query.filter(Outgoing.sum <= sum_to)

    def _filter_payment_date(self, date_from, date_to):
        if date_from:
            self.query = self.query.filter(
                Outgoing.date >= date_from
            )
        if date_to:
            self.query = self.query.filter(
                Outgoing.date <= date_to
            )
