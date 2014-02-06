# -*coding: utf-8-*-

from sqlalchemy import func

from . import ResourcesQueryBuilder
from ...models import DBSession
from ...models.resource import Resource
from ...models.employee import Employee
from ...models.employee_appointment import (
    EmployeeAppointmentH,
    EmployeeAppointmentR
)


class EmployeesAppointmentsQueryBuilder(ResourcesQueryBuilder):
    _fields = {
        'id': EmployeeAppointmentH.id,
        '_id': EmployeeAppointmentH.id,
        'appointment_date': EmployeeAppointmentH.appointment_date,
    }

    def __init__(self, context):
        super(EmployeesAppointmentsQueryBuilder, self).__init__(context)
        subquery = (
            DBSession.query(
                EmployeeAppointmentR.employees_appointments_h_id.label(
                    'header_id'
                ),
                func.array_to_string(
                    func.array_agg(Employee.name), ', '
                )
                .label('employees')
            )
            .join(
                Employee, EmployeeAppointmentR.employee
            )
            .group_by(EmployeeAppointmentR.employees_appointments_h_id)
            .subquery()
        )
        self.query = (
            self.query
            .join(
                EmployeeAppointmentH, Resource.employee_appointment
            )
            .join(subquery, subquery.c.header_id == EmployeeAppointmentH.id)
        )
        self._fields['employees'] = subquery.c.employees
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = self.query.add_columns(*fields)
