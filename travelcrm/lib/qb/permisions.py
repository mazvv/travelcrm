# -*coding: utf-8-*-

from . import ResourcesQueryBuilder
from ...models import DBSession
from ...models.resource import Resource
from ...models.resource_type import ResourceType
from ...models.permision import Permision


class PermisionsQueryBuilder(ResourcesQueryBuilder):
    _fields = {
        'id': ResourceType.id,
        '_id': ResourceType.id,
        'rt_humanize': ResourceType.humanize,
    }

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
        self.query = self.query.add_columns(*fields)
