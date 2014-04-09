# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.advsource import Advsource


class AdvsourcesQueryBuilder(ResourcesQueryBuilder):
    _fields = {
        'id': Advsource.id,
        '_id': Advsource.id,
        'name': Advsource.name,
    }
    _simple_search_fields = [
        Advsource.name,
    ]

    def __init__(self, context):
        super(AdvsourcesQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = self.query.join(Advsource, Resource.advsource)
        self.query = self.query.add_columns(*fields)

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Advsource.id.in_(id))
