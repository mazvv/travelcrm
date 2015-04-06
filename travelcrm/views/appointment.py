# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound

from ..models import DBSession
from ..models.appointment import Appointment
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.appointment import AppointmentQueryBuilder
from ..lib.utils.common_utils import translate as _
from travelcrm.forms.appointment import (
    AppointmentForm, 
    AppointmentSearchForm
)

log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.appointment.AppointmentResource',
)
class AppointmentView(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/appointment/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        form = AppointmentSearchForm(self.request, self.context)
        form.validate()
        qb = form.submit()
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized()
        }

    @view_config(
        name='view',
        request_method='GET',
        renderer='travelcrm:templates/appointment/form.mak',
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
        request_method='GET',
        renderer='travelcrm:templates/appointment/form.mak',
        permission='add'
    )
    def add(self):
        return {
            'title': _(u'Add Employee Appointment'),
        }

    @view_config(
        name='add',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        form = AppointmentForm(self.request)
        if form.validate():
            appointment = form.submit()
            DBSession.add(appointment)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': appointment.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='edit',
        request_method='GET',
        renderer='travelcrm:templates/appointment/form.mak',
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
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        appointment = Appointment.get(self.request.params.get('id'))
        form = AppointmentForm(self.request)
        if form.validate():
            form.submit(appointment)
            return {
                'success_message': _(u'Saved'),
                'response': appointment.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='copy',
        request_method='GET',
        renderer='travelcrm:templates/appointment/form.mak',
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
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _copy(self):
        return self._add()

    @view_config(
        name='delete',
        request_method='GET',
        renderer='travelcrm:templates/appointment/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Appointments'),
            'rid': self.request.params.get('rid')
        }

    @view_config(
        name='delete',
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
