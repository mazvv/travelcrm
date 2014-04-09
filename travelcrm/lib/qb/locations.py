# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.location import Location
from ...models.region import Region
from ...models.country import Country


class LocationsQueryBuilder(ResourcesQueryBuilder):
    _fields = {
        'id': Location.id,
        '_id': Location.id,
        'location_name': Location.name,
        'region_name': Region.name,
        'country_name': Country.name,
        'full_location_name': (
            Location.name + ' - ' + Region.name + ' (' + Country.name + ')'
        )
    }
    _simple_search_fields = [
        Location.name,
        Region.name,
        Country.name
    ]

    def __init__(self, context):
        super(LocationsQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = self.query.join(Location, Resource.location)
        self.query = self.query.join(Region, Location.region)
        self.query = self.query.join(Country, Region.country)
        self.query = self.query.add_columns(*fields)

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Location.id.in_(id))
