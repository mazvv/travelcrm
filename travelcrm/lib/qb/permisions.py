# -*coding: utf-8-*-

from . import ResourcesQueryBuilder
from ...models import DBSession
from ...models.resource import Resource
from ...models.resource_type import ResourceType
from ...models.permision import Permision

from ..bl.structures import query_recursive_tree


class PermisionsQueryBuilder(ResourcesQueryBuilder):
    _subq_structures_recursive = query_recursive_tree().subquery()
    _fields = {
        'id': ResourceType.id,
        '_id': ResourceType.id,
        'rt_humanize': ResourceType.humanize,
        'structure_path': _subq_structures_recursive.c.name_path
    }

    _simple_search_fields = [
        ResourceType.humanize,
    ]

    def __init__(self, position_id):
        super(PermisionsQueryBuilder, self).__init__()
        subq = (
            DBSession.query(Permision)
            .filter(
                Permision.condition_position_id(
                    position_id
                )
            )
            .subquery()
        )
        self._fields['permisions'] = subq.c.permisions
        self._fields['scope_type'] = subq.c.scope_type
        self._fields['structure_id'] = (
            subq.c.structure_id
        )
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = self.query.join(
            ResourceType, Resource.resource_type_obj
        )
        self.query = self.query.outerjoin(
            subq, ResourceType.id == subq.c.resource_type_id
        )
        self.query = self.query.outerjoin(
            self._subq_structures_recursive,
            self._subq_structures_recursive.c.id == subq.c.structure_id
        )
        self.query = self.query.add_columns(*fields)
