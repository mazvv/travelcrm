# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config
from pyramid.httpexceptions import HTTPFound

from ..models import DBSession
from ..models.appointment import Appointment
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.appointments import AppointmentsQueryBuilder
from ..lib.utils.common_utils import translate as _
from ..forms.appointments import (
    AppointmentSchema, 
    AppointmentSearchSchema
)

log = logging.getLogger(__name__)


class Appointments(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.appointments.Appointments',
        request_method='GET',
        renderer='travelcrm:templates/appointments/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.appointments.Appointments',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        schema = AppointmentSearchSchema().bind(request=self.request)
        controls = schema.deserialize(self.request.params.mixed())
        qb = AppointmentsQueryBuilder(self.context)
        qb.search_simple(controls.get('q'))
        qb.advanced_search(**controls)
        qb.filter_employee_id(
            self.request.params.get('employee_id')
        )
        qb.sort_query(
            self.request.params.get('sort'),
            self.request.params.get('order', 'asc')
        )
        qb.page_query(
            int(self.request.params.get('rows')),
            int(self.request.params.get('page'))
        )
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized()
        }

    @view_config(
        name='view',
        context='..resources.appointments.Appointments',
        request_method='GET',
        renderer='travelcrm:templates/appointments/form.mak',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            appointment = Appointment.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': appointment.id}
                )
            )
        result = self.edit()
        result.update({
            'title': _(u"View Appointment"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        context='..resources.appointments.Appointments',
        request_method='GET',
        renderer='travelcrm:templates/appointments/form.mak',
        permission='add'
    )
    def add(self):
        return {
            'title': _(u'Add Employee Appointment'),
        }

    @view_config(
        name='add',
        context='..resources.appointments.Appointments',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        schema = AppointmentSchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params.mixed())
            appointment = Appointment(
                date=controls.get('date'),
                employee_id=controls.get('employee_id'),
                position_id=controls.get('position_id'),
                currency_id=controls.get('currency_id'),
                salary=controls.get('salary'),
                resource=self.context.create_resource()
            )
            for id in controls.get('note_id'):
                note = Note.get(id)
                appointment.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                appointment.resource.tasks.append(task)
            DBSession.add(appointment)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': appointment.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.appointments.Appointments',
        request_method='GET',
        renderer='travelcrm:templates/appointments/form.mak',
        permission='edit'
    )
    def edit(self):
        appointment = Appointment.get(self.request.params.get('id'))
        return {
            'item': appointment,
            'title': _(u'Edit Employee Appointment')
        }

    @view_config(
        name='edit',
        context='..resources.appointments.Appointments',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        schema = AppointmentSchema().bind(request=self.request)
        appointment = Appointment.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params.mixed())
            appointment.date = controls.get('date')
            appointment.employee_id = controls.get('employee_id')
            appointment.position_id = controls.get('position_id')
            appointment.currency_id = controls.get('currency_id')
            appointment.salary = controls.get('salary')
            appointment.resource.notes = []
            appointment.resource.tasks = []
            for id in controls.get('note_id'):
                note = Note.get(id)
                appointment.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                appointment.resource.tasks.append(task)
            return {
                'success_message': _(u'Saved'),
                'response': appointment.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='copy',
        context='..resources.appointments.Appointments',
        request_method='GET',
        renderer='travelcrm:templates/appointments/form.mak',
        permission='add'
    )
    def copy(self):
        resources_type = Appointment.get(self.request.params.get('id'))
        return {
            'item': resources_type,
            'title': _(u"Copy Appointment")
        }

    @view_config(
        name='copy',
        context='..resources.appointments.Appointments',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _copy(self):
        return self._add()

    @view_config(
        name='delete',
        context='..resources.appointments.Appointments',
        request_method='GET',
        renderer='travelcrm:templates/appointments/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Appointments'),
            'rid': self.request.params.get('rid')
        }

    @view_config(
        name='delete',
        context='..resources.appointments.Appointments',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        errors = 0
        for id in self.request.params.getall('id'):
            item = Appointment.get(id)
            if item:
                DBSession.begin_nested()
                try:
                    DBSession.delete(item)
                    DBSession.commit()
                except:
                    errors += 1
                    DBSession.rollback()
        if errors > 0:
            return {
                'error_message': _(
                    u'Some objects could not be delete'
                ),
            }
        return {'success_message': _(u'Deleted')}
