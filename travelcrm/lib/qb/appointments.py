# -*coding: utf-8-*-

from collections import Iterable

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.employee import Employee
from ...models.position import Position
from ...models.appointment import Appointment

from ..bl.structures import query_recursive_tree


class AppointmentsQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(AppointmentsQueryBuilder, self).__init__(context)
        self._subq_structures_recursive = query_recursive_tree().subquery()
        self._fields = {
            'id': Appointment.id,
            '_id': Appointment.id,
            'date': Appointment.date,
            'employee_name': Employee.name,
            'position_name': Position.name,
            'structure_path': self._subq_structures_recursive.c.name_path
        }
        self._simple_search_fields = [
            Employee.first_name,
            Employee.last_name,
            Position.name,
            self._subq_structures_recursive.c.name,
        ]

        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = (
            self.query
            .join(Appointment, Resource.appointment)
            .join(Position, Appointment.position)
            .join(Employee, Appointment.employee)
            .join(
                  self._subq_structures_recursive,
                  self._subq_structures_recursive.c.id == Position.structure_id
            )
        )
        super(AppointmentsQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Appointment.id.in_(id))
