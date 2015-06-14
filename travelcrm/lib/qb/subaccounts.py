# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder

from ...models import DBSession
from ...models.resource import Resource
from ...models.resource_type import ResourceType
from ...models.account import Account
from ...models.subaccount import Subaccount
from ...models.currency import Currency

from ...lib.bl.subaccounts import query_resource_data


class SubaccountsQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(SubaccountsQueryBuilder, self).__init__(context)
        self._subq_resource_type = (
            DBSession.query(ResourceType.humanize, Resource.id)
            .join(Resource, ResourceType.resources)
            .subquery()
        )
        self._subq_resource_data = query_resource_data().subquery()
        self._fields = {
            'id': Subaccount.id,
            '_id': Subaccount.id,
            'account': Account.name,
            'name': Subaccount.name,
            'status': Subaccount.status,
            'title': self._subq_resource_data.c.title,
            'currency': Currency.iso_code,
            'resource_type': self._subq_resource_type.c.humanize,
        }
        self._simple_search_fields = [
            self._subq_resource_data.c.name,
            self._subq_resource_data.c.title,
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = (
            self.query
            .join(Subaccount, Resource.subaccount)
            .join(Account, Subaccount.account)
            .join(Currency, Account.currency)
            .join(
                self._subq_resource_data,
                self._subq_resource_data.c.subaccount_id
                == Subaccount.id
            )
            .join(
                self._subq_resource_type,
                self._subq_resource_type.c.id
                == self._subq_resource_data.c.resource_id
            )
        )
        super(SubaccountsQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Subaccount.id.in_(id))

    def advanced_search(self, **kwargs):
        super(SubaccountsQueryBuilder, self).advanced_search(**kwargs)
        if 'account_id' in kwargs:
            self._filter_account(kwargs.get('account_id'))

    def _filter_account(self, account_id):
        if account_id:
            self.query = self.query.filter(Account.id == account_id)
