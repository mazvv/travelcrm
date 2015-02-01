# -*coding: utf-8-*-

from collections import Iterable

from . import ResourcesQueryBuilder

from ...models.resource import Resource
from ...models.address import Address
from ...models.country import Country
from ...models.region import Region
from ...models.location import Location


class AddressesQueryBuilder(ResourcesQueryBuilder):


    def __init__(self, context):
        super(AddressesQueryBuilder, self).__init__(context)
        self._fields = {
            'id': Address.id,
            '_id': Address.id,
            'full_location_name': (
                Location.name + ' - ' + Region.name + ' (' + Country.name + ')'
            ),
            'location_name': Location.name,
            'region_name': Region.name,
            'country_name': Country.name,
            'zip_code': Address.zip_code,
            'address': Address.address,
        }
        self._simple_search_fields = [
            Location.name,
            Region.name,
            Country.name,
            Address.zip_code,
            Address.address
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = (
            self.query
            .join(Address, Resource.address)
            .join(Location, Address.location)
            .join(Region, Location.region)
            .join(Country, Region.country)
        )
        super(AddressesQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Address.id.in_(id))
