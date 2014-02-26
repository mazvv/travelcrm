# -*coding: utf-8-*-

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.country import Country


class CountriesQueryBuilder(ResourcesQueryBuilder):
    _fields = {
        'id': Country.id,
        '_id': Country.id,
        'iso_code': Country.iso_code,
        'country_name': Country.name
    }
    _simple_search_fields = [
        Country.iso_code,
        Country.name
    ]

    def __init__(self, context):
        super(CountriesQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = self.query.join(Country, Resource.country)
        self.query = self.query.add_columns(*fields)
