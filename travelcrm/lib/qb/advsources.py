# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.advsource import Advsource


class AdvsourcesQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(AdvsourcesQueryBuilder, self).__init__(context)
        self._fields = {
            'id': Advsource.id,
            '_id': Advsource.id,
            'name': Advsource.name,
        }
        self._simple_search_fields = [
            Advsource.name,
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = self.query.join(Advsource, Resource.advsource)
        super(AdvsourcesQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Advsource.id.in_(id))
