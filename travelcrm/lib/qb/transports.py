# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.transport import Transport


class TransportsQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(TransportsQueryBuilder, self).__init__(context)
        self._fields = {
            'id': Transport.id,
            '_id': Transport.id,
            'name': Transport.name
        }
        self._simple_search_fields = [
            Transport.name
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = self.query.join(Transport, Resource.transport)
        super(TransportsQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Transport.id.in_(id))
