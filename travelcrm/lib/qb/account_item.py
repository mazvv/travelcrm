# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.account_item import AccountItem


class AccountItemQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(AccountItemQueryBuilder, self).__init__(context)
        self._fields = {
            'id': AccountItem.id,
            '_id': AccountItem.id,
            'name': AccountItem.name,
        }
        self._simple_search_fields = [
            AccountItem.name
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = self.query.join(
            AccountItem, Resource.account_item
        )
        super(AccountItemQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(AccountItem.id.in_(id))
