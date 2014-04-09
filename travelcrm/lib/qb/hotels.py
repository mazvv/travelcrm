# -*coding: utf-8-*-
from collections import Iterable

from sqlalchemy import func

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.hotel import Hotel
from ...models.hotelcat import Hotelcat
from ...models.location import Location
from ...models.region import Region
from ...models.country import Country


class HotelsQueryBuilder(ResourcesQueryBuilder):
    _fields = {
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
    _simple_search_fields = [
        Hotel.name,
        Hotelcat.name,
        Location.name,
        Region.name,
        Country.name,
    ]

    def __init__(self, context):
        super(HotelsQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = self.query.join(Hotel, Resource.hotel)
        self.query = self.query.join(Hotelcat, Hotel.hotelcat)
        self.query = self.query.outerjoin(Location, Hotel.location)
        self.query = self.query.outerjoin(Region, Location.region)
        self.query = self.query.outerjoin(Country, Region.country)
        self.query = self.query.add_columns(*fields)

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Hotel.id.in_(id))
