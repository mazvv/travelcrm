# -*coding: utf-8-*-

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.employee import Employee
from ...models.position import Position
from ...models.appointment import Appointment

from ..bl.structures import query_recursive_tree


class AppointmentQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(AppointmentQueryBuilder, self).__init__(context)
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
        super(AppointmentQueryBuilder, self).build_query()

    def filter_structure_id(self, structure_id):
        self.query = self.query.filter(
            Position.condition_structure_id(structure_id)
        )

    def filter_employee_id(self, employee_id):
        if employee_id:
            self.query = self.query.filter(
                Appointment.condition_employee_id(employee_id)
            )
