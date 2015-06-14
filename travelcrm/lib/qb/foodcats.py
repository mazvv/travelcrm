# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.foodcat import Foodcat


class FoodcatsQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(FoodcatsQueryBuilder, self).__init__(context)
        self._fields = {
            'id': Foodcat.id,
            '_id': Foodcat.id,
            'name': Foodcat.name
        }
        self._simple_search_fields = [
            Foodcat.name
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = self.query.join(Foodcat, Resource.foodcat)
        super(FoodcatsQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Foodcat.id.in_(id))
