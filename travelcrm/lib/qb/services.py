# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.service import Service
from ...models.account_item import AccountItem


class ServicesQueryBuilder(ResourcesQueryBuilder):
    _fields = {
        'id': Service.id,
        '_id': Service.id,
        'name': Service.name,
        'account_item': AccountItem.name,
    }
    _simple_search_fields = [
        Service.name,
    ]

    def __init__(self, context):
        super(ServicesQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = (
            self.query
            .join(Service, Resource.service)
            .join(AccountItem, Service.account_item)
        )
        self.query = self.query.add_columns(*fields)

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Service.id.in_(id))
