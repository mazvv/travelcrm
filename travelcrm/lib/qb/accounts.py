# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.account import Account
from ...models.currency import Currency


class AccountsQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(AccountsQueryBuilder, self).__init__(context)
        self._fields = {
            'id': Account.id,
            '_id': Account.id,
            'name': Account.name,
            'account_type': Account.account_type,
            'display_text': Account.display_text,
            'currency': Currency.iso_code,
            'status': Account.status,
        }
        self._simple_search_fields = [
            Account.name,
            Currency.iso_code,
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = (
            self.query
            .join(Account, Resource.account)
            .join(Currency, Account.currency)
        )
        super(AccountsQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Account.id.in_(id))
