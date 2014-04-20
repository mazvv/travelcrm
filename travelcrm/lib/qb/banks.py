# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.bank import Bank


class BanksQueryBuilder(ResourcesQueryBuilder):
    _fields = {
        'id': Bank.id,
        '_id': Bank.id,
        'name': Bank.name
    }
    _simple_search_fields = [
        Bank.name
    ]

    def __init__(self, context):
        super(BanksQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = self.query.join(Bank, Resource.bank)
        self.query = self.query.add_columns(*fields)

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Bank.id.in_(id))
