# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.foodcat import Foodcat


class FoodcatsQueryBuilder(ResourcesQueryBuilder):
    _fields = {
        'id': Foodcat.id,
        '_id': Foodcat.id,
        'name': Foodcat.name
    }
    _simple_search_fields = [
        Foodcat.name
    ]

    def __init__(self, context):
        super(FoodcatsQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = self.query.join(Foodcat, Resource.foodcat)
        self.query = self.query.add_columns(*fields)

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Foodcat.id.in_(id))
