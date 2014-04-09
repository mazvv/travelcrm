# -*coding: utf-8-*-

from collections import (
    OrderedDict,
    Iterable
)

from sqlalchemy.orm import class_mapper
from sqlalchemy.orm.properties import RelationshipProperty

from . import ResourcesQueryBuilder

from ...models.resource import Resource
from ...models.address import Address
from ...models.country import Country
from ...models.region import Region
from ...models.location import Location


class AddressesQueryBuilder(ResourcesQueryBuilder):

    _fields = OrderedDict({
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
    })

    _simple_search_fields = [
        Location.name,
        Region.name,
        Country.name,
        Address.zip_code,
        Address.address
    ]

    def __init__(self, context):
        super(AddressesQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = (
            self.query
            .join(Address, Resource.address)
            .join(Location, Address.location)
            .join(Region, Location.region)
            .join(Country, Region.country)
        )
        self.query = self.query.add_columns(*fields)

    def filter_reference(self, ref_name, ref_id):
        for item in class_mapper(Address).iterate_properties:
            if isinstance(item, RelationshipProperty) and item.key == ref_name:
                ref_cls = item.mapper.class_
                self.query = (
                    self.query
                    .join(ref_cls, getattr(Address, ref_name))
                    .filter(ref_cls.id == ref_id)
                )
                return
        raise ValueError(
            u"Can't find given ref_name %{ref_name}".format(ref_name)
        )

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Address.id.in_(id))
