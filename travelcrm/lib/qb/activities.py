# -*coding: utf-8-*-

from ...models import DBSession
from ...models.resource import Resource
from ...models.resource_type import ResourceType 
from ...models.resource_log import ResourceLog
from ...lib.qb import GeneralQueryBuilder


class ActivitiesQueryBuilder(GeneralQueryBuilder):

    def __init__(self, context=None):
        self._subq_log = (
            DBSession.query(
                ResourceLog.resource_id, 
                ResourceLog.modifydt,
                ResourceLog.employee_id,
            )
            .distinct(ResourceLog.resource_id)
            .subquery()
        )
        self._fields = {
            'id': Resource.id,
            'resource_type': ResourceType.humanize,
            'modifydt': self._subq_log.c.modifydt,
        }
        self.build_query()

    def build_query(self):
        self.query = (
            DBSession.query(Resource)
            .join(ResourceType, Resource.resource_type)
            .join(self._subq_log, self._subq_log.c.resource_id == Resource.id)
            .order_by(self._subq_log.c.modifydt.desc())
        )
        super(ActivitiesQueryBuilder, self).build_query()

    def advanced_search(self, **kwargs):
        if 'employee_id' in kwargs:
            self._filter_employee(kwargs.get('employee_id'))

    def _filter_employee(self, employee_id):
        if employee_id:
            self.query = self.query.filter(
                self._subq_log.c.employee_id == employee_id
            )
