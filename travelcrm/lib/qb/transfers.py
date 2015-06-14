# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.transfer import Transfer


class TransfersQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(TransfersQueryBuilder, self).__init__(context)
        self._fields = {
            'id': Transfer.id,
            '_id': Transfer.id,
            'name': Transfer.name
        }
        self._simple_search_fields = [
            Transfer.name
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = self.query.join(Transfer, Resource.transfer)
        super(TransfersQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Transfer.id.in_(id))
