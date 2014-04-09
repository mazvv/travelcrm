# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.hotelcat import Hotelcat


class HotelcatsQueryBuilder(ResourcesQueryBuilder):
    _fields = {
        'id': Hotelcat.id,
        '_id': Hotelcat.id,
        'name': Hotelcat.name
    }
    _simple_search_fields = [
        Hotelcat.name
    ]

    def __init__(self, context):
        super(HotelcatsQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = self.query.join(Hotelcat, Resource.hotelcat)
        self.query = self.query.add_columns(*fields)

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Hotelcat.id.in_(id))
