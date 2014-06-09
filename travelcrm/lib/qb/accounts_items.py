# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.account_item import AccountItem


class AccountsItemsQueryBuilder(ResourcesQueryBuilder):
    _fields = {
        'id': AccountItem.id,
        '_id': AccountItem.id,
        'name': AccountItem.name,
        'item_type': AccountItem.item_type,
    }
    _simple_search_fields = [
        AccountItem.name
    ]

    def __init__(self, context):
        super(AccountsItemsQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = self.query.join(AccountItem, Resource.account_item)
        self.query = self.query.add_columns(*fields)

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(AccountItem.id.in_(id))
