# -*coding: utf-8-*-

from collections import Iterable

from . import ResourcesQueryBuilder

from ...models.resource import Resource
from ...models.position import Position

from ..bl.structures import query_recursive_tree


class PositionsQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(PositionsQueryBuilder, self).__init__(context)
        self._subq_structures_recursive = query_recursive_tree().subquery()
        self._fields = {
            'id': Position.id,
            '_id': Position.id,
            'position_name': Position.name,
            'structure_id': Position.structure_id,
            'structure_path': self._subq_structures_recursive.c.name_path
        }
        self._simple_search_fields = [
            Position.name,
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = (
            self.query
            .join(Position, Resource.position)
            .join(
                self._subq_structures_recursive,
                self._subq_structures_recursive.c.id == Position.structure_id
            )
        )
        super(PositionsQueryBuilder, self).build_query()

    def filter_structure_id(self, structure_id):
        self.query = self.query.filter(
            Position.condition_structure_id(structure_id)
        )

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Position.id.in_(id))
