# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.hotel import Hotel
from ...models.hotelcat import Hotelcat
from ...models.location import Location
from ...models.region import Region
from ...models.country import Country


class HotelsQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(HotelsQueryBuilder, self).__init__(context)
        self._fields = {
            'id': Hotel.id,
            '_id': Hotel.id,
            'name': Hotel.name,
            'full_hotel_name': Hotel.name + ' (' + Hotelcat.name + ')',
            'hotelcat_name': Hotelcat.name,
            'location_name': Location.name,
            'region_name': Region.name,
            'country_name': Country.name,
            'full_location_name': (
                Location.name + ' - ' + Region.name + ' (' + Country.name + ')'
            )
        }
        self._simple_search_fields = [
            Hotel.name,
            Hotelcat.name,
            Location.name,
            Region.name,
            Country.name,
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = (
            self.query
            .join(Hotel, Resource.hotel)
            .join(Hotelcat, Hotel.hotelcat)
            .outerjoin(Location, Hotel.location)
            .outerjoin(Region, Location.region)
            .outerjoin(Country, Region.country)
        )
        super(HotelsQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Hotel.id.in_(id))
