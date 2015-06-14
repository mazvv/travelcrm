# -*-coding: utf-8 -*-

import colander

from . import (
    ResourceSchema,
    BaseForm,
    BaseSearchForm,
    Date
)
from ..resources.appointments import AppointmentsResource
from ..models.appointment import Appointment
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.appointments import AppointmentsQueryBuilder


class _AppointmentSchema(ResourceSchema):
    date = colander.SchemaNode(
        Date(),
    )
    employee_id = colander.SchemaNode(
        colander.Integer(),
    )
    position_id = colander.SchemaNode(
        colander.Integer(),
    )
    salary = colander.SchemaNode(
        colander.Money(),
    )
    currency_id = colander.SchemaNode(
        colander.Integer(),
    )


class AppointmentForm(BaseForm):
    _schema = _AppointmentSchema

    def submit(self, appointment=None):
        context = AppointmentsResource(self.request)
        if not appointment:
            appointment = Appointment(
                resource=context.create_resource()
            )
        else:
            appointment.resource.notes = []
            appointment.resource.tasks = []
        appointment.name = self._controls.get('name')
        for id in self._controls.get('note_id'):
            note = Note.get(id)
            appointment.resource.notes.append(note)
        for id in self._controls.get('task_id'):
            task = Task.get(id)
            appointment.resource.tasks.append(task)
        return appointment


class AppointmentSearchForm(BaseSearchForm):
    _qb = AppointmentsQueryBuilder
