# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.roomcat import Roomcat


class RoomcatsQueryBuilder(ResourcesQueryBuilder):
    _fields = {
        'id': Roomcat.id,
        '_id': Roomcat.id,
        'name': Roomcat.name
    }
    _simple_search_fields = [
        Roomcat.name
    ]

    def __init__(self, context):
        super(RoomcatsQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = self.query.join(Roomcat, Resource.roomcat)
        self.query = self.query.add_columns(*fields)

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Roomcat.id.in_(id))
