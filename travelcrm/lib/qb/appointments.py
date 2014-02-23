# -*coding: utf-8-*-

from collections import OrderedDict
from sqlalchemy import func

from . import (
    GeneralQueryBuilder,
    ResourcesQueryBuilder
)
from ...models import DBSession
from ...models.resource import Resource
from ...models.employee import Employee
from ...models.position import Position
from ...models.structure import Structure
from ...models.appointment import Appointment
from ...models.appointment_row import AppointmentRow
from ...models.tappointment_row import TAppointmentRow


class AppointmentsQueryBuilder(ResourcesQueryBuilder):
    _fields = {
        'id': Appointment.id,
        '_id': Appointment.id,
        'appointment_date': Appointment.appointment_date,
    }

    def __init__(self, context):
        super(AppointmentsQueryBuilder, self).__init__(context)
        subquery = (
            DBSession.query(
                AppointmentRow.appointment_id.label(
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
            .group_by(AppointmentRow.appointment_id)
            .subquery()
        )
        self.query = (
            self.query
            .join(
                Appointment, Resource.appointment
            )
            .join(subquery, subquery.c.header_id == Appointment.id)
        )
        self._fields['employees'] = subquery.c.employees
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = self.query.add_columns(*fields)


class AppointmentsRowsQueryBuilder(GeneralQueryBuilder):
    _fields = OrderedDict({
        'id': AppointmentRow.id,
        '_id': AppointmentRow.id,
        'employee_name': Employee.name,
        'position_name': Position.name,
        'employee_id': Employee.id,
        'position_id': Position.id,
        'structure_id': Structure.id,
        'structure_name': Structure.name,
    })

    def __init__(self):
        fields = GeneralQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = (
            DBSession.query(*fields)
            .join(Employee, AppointmentRow.employee)
            .join(Position, AppointmentRow.position)
            .join(Structure, Position.structure)
        )

    def union_temporal(self, temporal_id, appointment_id):
        fields = self._fields.copy()
        fields['id'] = -TAppointmentRow.id
        fields['_id'] = TAppointmentRow.id

        fields = GeneralQueryBuilder.get_fields_with_labels(fields)

        subq = DBSession.query(TAppointmentRow.main_id)
        subq = subq.filter(
            TAppointmentRow.temporal_id == temporal_id,
            TAppointmentRow.main_id != None
        )
        subq = subq.subquery()

        self.query = self.query.filter(
            AppointmentRow.appointment_id == appointment_id,
            ~ AppointmentRow.id.in_(subq)
        )
        union_query = (
            DBSession.query(*fields)
            .join(Employee, TAppointmentRow.employee)
            .join(Position, TAppointmentRow.position)
            .join(Structure, Position.structure)
            .filter(TAppointmentRow.temporal_id == temporal_id)
            .filter(TAppointmentRow.deleted == False)
        )
        self.query = self.query.union(union_query)
