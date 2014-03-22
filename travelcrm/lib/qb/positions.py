# -*coding: utf-8-*-

from . import ResourcesQueryBuilder

from ...models.resource import Resource
from ...models.position import Position


class PositionsQueryBuilder(ResourcesQueryBuilder):
    _fields = {
        'id': Position.id,
        '_id': Position.id,
        'position_name': Position.name,
    }

    _simple_search_fields = [
        Position.name,
    ]

    def __init__(self, context):
        super(PositionsQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = self.query.join(
            Position, Resource.position
        )
        self.query = self.query.add_columns(*fields)

    def filter_structure_id(self, structure_id):
        self.query = self.query.filter(
            Position.condition_structure_id(structure_id)
        )
