# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.country import Country


class CountriesQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(CountriesQueryBuilder, self).__init__(context)
        self._fields = {
            'id': Country.id,
            '_id': Country.id,
            'iso_code': Country.iso_code,
            'country_name': Country.name
        }
        self._simple_search_fields = [
            Country.iso_code,
            Country.name
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = self.query.join(Country, Resource.country)
        super(CountriesQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Country.id.in_(id))
