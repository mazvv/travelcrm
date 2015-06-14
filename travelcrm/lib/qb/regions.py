# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.region import Region
from ...models.country import Country


class RegionsQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(RegionsQueryBuilder, self).__init__(context)
        self._fields = {
            'id': Region.id,
            '_id': Region.id,
            'region_name': Region.name,
            'country_name': Country.name,
            'full_region_name': Region.name + ' (' + Country.name + ')'
        }
        self._simple_search_fields = [
            Region.name,
            Country.name
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = (
            self.query
            .join(Region, Resource.region)
            .join(Country, Region.country)
        )
        super(RegionsQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Region.id.in_(id))
