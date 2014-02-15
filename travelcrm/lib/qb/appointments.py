# -*coding: utf-8-*-

from sqlalchemy import func

from . import (
    GeneralQueryBuilder,
    ResourcesQueryBuilder
)
from ...models import DBSession
from ...models.resource import Resource
from ...models.employee import Employee
from ...models.position import Position
from ...models.appointment import (
    AppointmentHeader,
    AppointmentRow
)


class AppointmentsQueryBuilder(ResourcesQueryBuilder):
    _fields = {
        'id': AppointmentHeader.id,
        '_id': AppointmentHeader.id,
        'appointment_date': AppointmentHeader.appointment_date,
    }

    def __init__(self, context):
        super(AppointmentsQueryBuilder, self).__init__(context)
        subquery = (
            DBSession.query(
                AppointmentRow.appointment_header_id.label(
                    'header_id'
                ),
                func.array_to_string(
                    func.array_agg(Employee.name), ', '
                )
                .label('employees')
            )
            .join(
                Employee, AppointmentRow.employee
            )
            .group_by(AppointmentRow.appointment_header_id)
            .subquery()
        )
        self.query = (
            self.query
            .join(
                AppointmentHeader, Resource.appointment
            )
            .join(subquery, subquery.c.header_id == AppointmentHeader.id)
        )
        self._fields['employees'] = subquery.c.employees
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = self.query.add_columns(*fields)


class AppointmentsRowsQueryBuilder(GeneralQueryBuilder):
    _fields = {
        'id': AppointmentRow.id,
        '_id': AppointmentRow.id,
        'employee_name': Employee.name,
        'position_name': Position.name,
    }

    def __init__(self):
        fields = GeneralQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = (
            DBSession.query(*fields)
            .join(Employee, AppointmentRow.employee)
            .join(Position, AppointmentRow.position)
        )

    def filter_uuid(self, uuid):
        self.query = self.query.filter(AppointmentRow.uuid == uuid)

    def filter_appointment_header_id(self, appointment_header_id):
        self.query = self.query.filter(
            AppointmentRow.appointment_header_id == appointment_header_id
        )
