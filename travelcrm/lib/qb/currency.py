# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.currency import Currency


class CurrencyQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(CurrencyQueryBuilder, self).__init__(context)
        self._fields = {
            'id': Currency.id,
            '_id': Currency.id,
            'iso_code': Currency.iso_code,
        }
        self._simple_search_fields = [
            Currency.iso_code,
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = self.query.join(Currency, Resource.currency)
        super(CurrencyQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Currency.id.in_(id))
