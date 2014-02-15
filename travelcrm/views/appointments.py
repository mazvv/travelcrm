# -*-coding: utf-8-*-

import logging
import colander
from uuid import uuid4
from babel.dates import parse_date

from pyramid.view import view_config

from ..models import DBSession
from ..models.appointment import (
    AppointmentHeader,
    AppointmentRow
)
from ..lib.qb.appointments import (
    AppointmentsQueryBuilder,
    AppointmentsRowsQueryBuilder
)
from ..lib.utils.common_utils import get_locale_name
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
        uuid = uuid4()
        return {'title': _(u'Add Employees Appointments'), 'uuid': str(uuid)}

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
                appointment_date=parse_date(
                    controls.get('appointment_date'), get_locale_name()
                ),
                resource=self.context.create_resource(controls.get('status'))
            )
            uuid = controls.get('uuid')
            doc.rows = (
                DBSession.query(AppointmentRow)
                .filter(AppointmentRow.condition_uuid(uuid))
                .all()
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
        doc = AppointmentHeader.get(self.request.params.get('id'))
        uuid = doc.rows[0].uuid
        return {'item': doc, 'title': _(u'Edit Appointment'), 'uuid': uuid}

    @view_config(
        name='edit',
        context='..resources.appointments.Appointments',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        _ = self.request.translate
        schema = AppointmentSchema().bind(request=self.request)
        doc = AppointmentHeader.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params)
            doc.appointment_date = parse_date(
                controls.get('appointment_date'), get_locale_name()
            ),
            doc.resource.status = controls.get('status')
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
            appointment = AppointmentHeader.get(id)
            if appointment:
                DBSession.delete(appointment)
        return {'success_message': _(u'Deleted')}

    @view_config(
        name='rows',
        context='..resources.appointments.Appointments',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _rows(self):
        qb = AppointmentsRowsQueryBuilder()
        uuid = self.request.params.get('uuid')
        if uuid:
            qb.filter_uuid(uuid)
        qb.sort_query(
            self.request.params.get('sort'),
            self.request.params.get('order', 'asc')
        )
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized()
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
            controls = schema.deserialize(self.request.params)
            row = AppointmentRow(
                position_id=controls.get('position_id'),
                employee_id=controls.get('employee_id'),
            )
            if not controls.get('appointment_header_id'):
                row.uuid = controls.get('uuid')
            else:
                row.appointment_header_id = controls.get(
                    'appointment_header_id'
                )
            DBSession.add(row)
            return {'success_message': _(u'Saved')}
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='delete_row',
        context='..resources.appointments.Appointments',
        request_method='GET',
        renderer='travelcrm:templates/appointments/delete_row.mak',
        permission='delete'
    )
    def delete_row(self):
        return {
            'rid': self.request.params.get('rid')
        }

    @view_config(
        name='delete_row',
        context='..resources.appointments.Appointments',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete_row(self):
        _ = self.request.translate
        for id in self.request.params.getall('id'):
            row = AppointmentRow.get(id)
            if row:
                DBSession.delete(row)
        return {'success_message': _(u'Deleted')}
