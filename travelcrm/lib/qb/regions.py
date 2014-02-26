# -*coding: utf-8-*-

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.region import Region
from ...models.country import Country


class RegionsQueryBuilder(ResourcesQueryBuilder):
    _fields = {
        'id': Region.id,
        '_id': Region.id,
        'region_name': Region.name,
        'country_name': Country.name
    }
    _simple_search_fields = [
        Region.name,
        Country.name
    ]

    def __init__(self, context):
        super(RegionsQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = self.query.join(Region, Resource.region)
        self.query = self.query.join(Country, Region.country)
        self.query = self.query.add_columns(*fields)
