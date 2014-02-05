# -*coding: utf-8-*-

from . import ResourcesQueryBuilder
from ...models import DBSession
from ...models.resource import Resource
from ...models.resource_type import ResourceType
from ...models.position_permision import PositionPermision


class PositionsPermisionsQueryBuilder(ResourcesQueryBuilder):
    _fields = {
        'id': ResourceType.id,
        '_id': ResourceType.id,
        'rt_humanize': ResourceType.humanize,
    }

    def __init__(self, company_position_id):
        super(PositionsPermisionsQueryBuilder, self).__init__()
        subq = (
            DBSession.query(PositionPermision)
            .filter(
                PositionPermision.condition_company_position_id(
                    company_position_id
                )
            )
            .subquery()
        )
        self._fields['permisions'] = subq.c.permisions
        self._fields['scope_type'] = subq.c.scope_type
        self._fields['companies_structures_id'] = (
            subq.c.companies_structures_id
        )
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = self.query.join(
            ResourceType, Resource.resource_type_obj
        )
        self.query = self.query.outerjoin(
            subq, ResourceType.id == subq.c.resources_types_id
        )
        self.query = self.query.add_columns(*fields)
