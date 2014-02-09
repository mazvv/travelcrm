# -*-coding: utf-8-*-

import logging
import colander
import datetime

from pyramid.view import view_config

from ..models import DBSession
from ..models.appointment import (
    AppointmentHeader,
    AppointmentRow
)
from ..lib.qb.appointments import AppointmentsQueryBuilder

from ..forms.appointments import (
    AppointmentRowSchema,
    AppointmentSchema
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
        qb = AppointmentsQueryBuilder(self.context)
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
        name='add',
        context='..resources.appointments.Appointments',
        request_method='GET',
        renderer='travelcrm:templates/appointments/form.mak',
        permission='add'
    )
    def add(self):
        _ = self.request.translate
        return {'title': _(u'Add Employees Appointments')}

    @view_config(
        name='add',
        context='..resources.appointments.Appointments',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        _ = self.request.translate
        schema = AppointmentSchema().bind(request=self.request)

        try:
            controls = schema.deserialize(self.request.params)
            doc = AppointmentHeader(
                appointment_date=datetime.date.today(),
                resource=self.context.create_resource(controls.get('status'))
            )
            doc.rows.append(
                AppointmentRow(
                    employees_id=2,
                    companies_positions_id=4
                )
            )
            DBSession.add(doc)
            return {'success_message': _(u'Saved')}
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
        _ = self.request.translate
        employee = Employee.get(self.request.params.get('id'))
        return {'item': employee, 'title': _(u'Edit Employee')}

    @view_config(
        name='edit',
        context='..resources.appointments.Appointments',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        _ = self.request.translate
        schema = EmployeeSchema().bind(request=self.request)
        employee = Employee.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params)
            employee.first_name = controls.get('first_name')
            employee.last_name = controls.get('last_name')
            employee.second_name = controls.get('second_name')
            employee.resource.status = controls.get('status')
            return {'success_message': _(u'Saved')}
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='add_row',
        context='..resources.appointments.Appointments',
        request_method='GET',
        renderer='travelcrm:templates/appointments/form_row.mak',
        permission='add'
    )
    def add_row(self):
        _ = self.request.translate
        return {'title': _(u'Add Row')}

    @view_config(
        name='add_row',
        context='..resources.appointments.Appointments',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add_row(self):
        _ = self.request.translate
        schema = AppointmentRowSchema().bind(request=self.request)
        try:
            schema.deserialize(self.request.params)
            return {'success_message': _(u'Saved')}
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='delete',
        context='..resources.appointments.Appointments',
        request_method='GET',
        renderer='travelcrm:templates/appointments/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
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
        _ = self.request.translate
        for id in self.request.params.getall('id'):
            employee = Employee.get(id)
            if employee:
                DBSession.delete(employee)
        return {'success_message': _(u'Deleted')}
