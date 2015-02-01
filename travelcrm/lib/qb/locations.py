# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.location import Location
from ...models.region import Region
from ...models.country import Country


class LocationsQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(LocationsQueryBuilder, self).__init__(context)
        self._fields = {
            'id': Location.id,
            '_id': Location.id,
            'location_name': Location.name,
            'region_name': Region.name,
            'country_name': Country.name,
            'full_location_name': (
                Location.name + ' - ' + Region.name + ' (' + Country.name + ')'
            )
        }
        self._simple_search_fields = [
            Location.name,
            Region.name,
            Country.name
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = (
            self.query
            .join(Location, Resource.location)
            .join(Region, Location.region)
            .join(Country, Region.country)
        )
        super(LocationsQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Location.id.in_(id))
