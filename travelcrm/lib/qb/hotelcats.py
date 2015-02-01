# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.hotelcat import Hotelcat


class HotelcatsQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(HotelcatsQueryBuilder, self).__init__(context)
        self._fields = {
            'id': Hotelcat.id,
            '_id': Hotelcat.id,
            'name': Hotelcat.name
        }
        self._simple_search_fields = [
            Hotelcat.name
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = self.query.join(Hotelcat, Resource.hotelcat)
        super(HotelcatsQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Hotelcat.id.in_(id))
