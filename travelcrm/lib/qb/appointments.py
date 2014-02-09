# -*coding: utf-8-*-

from sqlalchemy import func

from . import ResourcesQueryBuilder
from ...models import DBSession
from ...models.resource import Resource
from ...models.employee import Employee
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
