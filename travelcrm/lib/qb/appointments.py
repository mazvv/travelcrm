# -*coding: utf-8-*-

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.employee import Employee
from ...models.position import Position
from ...models.appointment import Appointment

from ..bl.structures import query_recursive_tree


class AppointmentsQueryBuilder(ResourcesQueryBuilder):
    _subq_structures_recursive = query_recursive_tree().subquery()
    _fields = {
        'id': Appointment.id,
        '_id': Appointment.id,
        'date': Appointment.date,
        'employee_name': Employee.name,
        'position_name': Position.name,
        'structure_path': _subq_structures_recursive.c.name_path
    }
    _simple_search_fields = [
        Employee.first_name,
        Employee.last_name,
        Position.name,
        _subq_structures_recursive.c.name,
    ]

    def __init__(self, context):
        super(AppointmentsQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = self.query.join(
            Appointment, Resource.appointment
        )
        self.query = self.query.join(
            Position, Appointment.position
        )
        self.query = self.query.join(
            Employee, Appointment.employee
        )
        self.query = self.query.join(
            self._subq_structures_recursive,
            self._subq_structures_recursive.c.id == Position.structure_id
        )
        self.query = self.query.add_columns(*fields)

    def filter_structure_id(self, structure_id):
        self.query = self.query.filter(
            Position.condition_structure_id(structure_id)
        )

    def filter_employee_id(self, employee_id):
        if employee_id:
            self.query = self.query.filter(
                Appointment.condition_employee_id(employee_id)
            )
