# -*coding: utf-8-*-

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.currency import Currency


class CurrenciesQueryBuilder(ResourcesQueryBuilder):
    _fields = {
        'id': Currency.id,
        '_id': Currency.id,
        'iso_code': Currency.iso_code,
    }

    _simple_search_fields = [
        Currency.iso_code,
    ]

    def __init__(self, context):
        super(CurrenciesQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = self.query.join(Currency, Resource.currency)
        self.query = self.query.add_columns(*fields)

    def filter_id(self, id):
        if id:
            self.query = self.query.filter(Currency.id == id)
