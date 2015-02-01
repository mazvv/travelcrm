# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder

from ...models.resource import Resource
from ...models.touroperator import Touroperator


class TouroperatorsQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(TouroperatorsQueryBuilder, self).__init__(context)
        self._fields = {
            'id': Touroperator.id,
            '_id': Touroperator.id,
            'name': Touroperator.name
        }
        self._simple_search_fields = [
            Touroperator.name,
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = self.query.join(Touroperator, Resource.touroperator)
        super(TouroperatorsQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Touroperator.id.in_(id))
