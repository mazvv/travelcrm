# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.bank import Bank


class BankQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(BankQueryBuilder, self).__init__(context)
        self._fields = {
            'id': Bank.id,
            '_id': Bank.id,
            'name': Bank.name
        }
        self._simple_search_fields = [
            Bank.name
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = self.query.join(Bank, Resource.bank)
        super(BankQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Bank.id.in_(id))
