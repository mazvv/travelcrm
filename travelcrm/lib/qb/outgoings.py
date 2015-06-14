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

    def __init__(self, context):
        super(OutgoingsQueryBuilder, self).__init__(context)
        self._subq_subaccount_type = (
            DBSession.query(ResourceType.humanize, Resource.id)
            .join(Resource, ResourceType.resources)
            .subquery()
        )
        self._subq_subaccount_data = query_resource_data().subquery()
        self._fields = {
            'id': Outgoing.id,
            '_id': Outgoing.id,
            'date': Outgoing.date,
            'sum': Outgoing.sum,
            'account': Account.name,
            'account_item': AccountItem.name,
            'currency': Currency.iso_code,
            'resource': self._subq_subaccount_data.c.title,
            'resource_type': self._subq_subaccount_type.c.humanize,
        }
        self._simple_search_fields = [
            Account.name,
            self._subq_subaccount_data.c.name,
            self._subq_subaccount_data.c.title,
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
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
        super(OutgoingsQueryBuilder, self).build_query()

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
        if 'sum_from' in kwargs or 'sum_to' in kwargs:
            self._filter_sum(
                kwargs.get('sum_from'), kwargs.get('sum_to')
            )

    def _filter_account_item(self, account_item_id):
        if account_item_id:
            self.query = self.query.filter(
                AccountItem.id == account_item_id
            )

    def _filter_account(self, account_id):
        if account_id:
            self.query = self.query.filter(Account.id == account_id)

    def _filter_sum(self, sum_from, sum_to):
        if sum_from:
            self.query = self.query.filter(Outgoing.sum >= sum_from)
        if sum_to:
            self.query = self.query.filter(Outgoing.sum <= sum_to)
