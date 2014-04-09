# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder

from ...models.resource import Resource
from ...models.touroperator import Touroperator


class TouroperatorsQueryBuilder(ResourcesQueryBuilder):
    _fields = {
        'id': Touroperator.id,
        '_id': Touroperator.id,
        'name': Touroperator.name
    }

    _simple_search_fields = [
        Touroperator.name,
    ]

    def __init__(self, context):
        super(TouroperatorsQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = self.query.join(Touroperator, Resource.touroperator)
        self.query = self.query.add_columns(*fields)

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Touroperator.id.in_(id))
