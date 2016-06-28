# -*-coding: utf-8 -*-

import colander

from . import (
    SelectInteger,
    ResourceSchema,
    BaseForm,
    BaseSearchForm,
    BaseAssignForm,
    Date
)
from ..resources.appointments import AppointmentsResource
from ..models.appointment import Appointment
from ..models.currency import Currency
from ..models.position import Position
from ..models.employee import Employee
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.appointments import AppointmentsQueryBuilder
from ..lib.utils.security_utils import get_auth_employee


class _AppointmentSchema(ResourceSchema):
    date = colander.SchemaNode(
        Date(),
    )
    employee_id = colander.SchemaNode(
        SelectInteger(Employee),
    )
    position_id = colander.SchemaNode(
        SelectInteger(Position),
    )
    salary = colander.SchemaNode(
        colander.Money(),
    )
    currency_id = colander.SchemaNode(
        SelectInteger(Currency),
    )


class AppointmentForm(BaseForm):
    _schema = _AppointmentSchema

    def submit(self, appointment=None):
        if not appointment:
            appointment = Appointment(
                resource=AppointmentsResource.create_resource(
                    get_auth_employee(self.request)
                )
            )
        else:
            appointment.resource.notes = []
            appointment.resource.tasks = []
        appointment.date = self._controls.get('date')
        appointment.employee_id = self._controls.get('employee_id')
        appointment.position_id = self._controls.get('position_id')
        appointment.salary = self._controls.get('salary')
        appointment.currency_id = self._controls.get('currency_id')
        for id in self._controls.get('note_id'):
            note = Note.get(id)
            appointment.resource.notes.append(note)
        for id in self._controls.get('task_id'):
            task = Task.get(id)
            appointment.resource.tasks.append(task)
        return appointment


class AppointmentSearchForm(BaseSearchForm):
    _qb = AppointmentsQueryBuilder


class AppointmentAssignForm(BaseAssignForm):
    def submit(self, ids):
        for id in ids:
            appointment = Appointment.get(id)
            appointment.resource.maintainer_id = self._controls.get(
                'maintainer_id'
            )
