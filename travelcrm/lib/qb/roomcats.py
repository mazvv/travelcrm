# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.roomcat import Roomcat


class RoomcatsQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(RoomcatsQueryBuilder, self).__init__(context)
        self._fields = {
            'id': Roomcat.id,
            '_id': Roomcat.id,
            'name': Roomcat.name
        }
        self._simple_search_fields = [
            Roomcat.name
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = self.query.join(Roomcat, Resource.roomcat)
        super(RoomcatsQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Roomcat.id.in_(id))
