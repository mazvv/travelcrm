# -*coding: utf-8-*-

from . import ResourcesQueryBuilder
from ...models import DBSession
from ...models.resource import Resource
from ...models.resource_type import ResourceType
from ...models.permision import Permision

from ..bl.structures import query_recursive_tree


class PermisionsQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, position_id):
        super(PermisionsQueryBuilder, self).__init__()
        self.position_id = position_id
        self._subq_structures_recursive = query_recursive_tree().subquery()
        self._fields = {
            'id': ResourceType.id,
            '_id': ResourceType.id,
            'rt_humanize': ResourceType.humanize,
            'structure_path': self._subq_structures_recursive.c.name_path
        }
        self._simple_search_fields = [
            ResourceType.humanize,
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        subq = (
            DBSession.query(Permision)
            .filter(
                Permision.condition_position_id(
                    self.position_id
                )
            )
            .subquery()
        )
        self.update_fields({
            'permisions': subq.c.permisions,
            'scope_type': subq.c.scope_type,
            'structure_id': subq.c.structure_id
        })
        self.query = (
            self.query
            .join(ResourceType, Resource.resource_type_obj)
            .outerjoin(subq, ResourceType.id == subq.c.resource_type_id)
            .outerjoin(
                self._subq_structures_recursive,
                self._subq_structures_recursive.c.id == subq.c.structure_id
            )
        )
        super(PermisionsQueryBuilder, self).build_query()
