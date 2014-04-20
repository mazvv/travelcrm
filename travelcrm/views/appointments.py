# -*-coding: utf-8-*-

import logging
import colander
from babel.dates import parse_date

from pyramid.view import view_config

from ..models import DBSession
from ..models.appointment import Appointment
from ..models.appointment_row import AppointmentRow

from ..lib.qb.appointments import (
    AppointmentsQueryBuilder,
    AppointmentsRowsQueryBuilder
)
from ..lib.utils.common_utils import (
    get_locale_name,
    translate as _
)
from ..forms.appointments import (
    AppointmentSchema,
    TAppointmentRowSchema,
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
        temporal = Temporal()
        DBSession.add(temporal)
        return {
            'title': _(u'Add Employees Appointments'),
            'tid': temporal.id,
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
            controls = schema.deserialize(self.request.params)
            temporal = Temporal.get(controls.get('tid'))
            doc = Appointment(
                appointment_date=parse_date(
                    controls.get('appointment_date'), get_locale_name()
                ),
                resource=self.context.create_resource(controls.get('status'))
            )
            rows = temporal.tappointment_rows.filter(
                TAppointmentRow.deleted == False
            )
            for row in rows:
                doc.rows.append(
                    AppointmentRow(
                        position_id=row.position_id,
                        employee_id=row.employee_id
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
        doc = Appointment.get(self.request.params.get('id'))
        temporal = Temporal()
        DBSession.add(temporal)
        return {
            'item': doc,
            'tid': temporal.id,
            'title': _(u'Edit Appointment')
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
        doc = Appointment.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params)
            temporal = Temporal.get(controls.get('tid'))
            doc.appointment_date = parse_date(
                controls.get('appointment_date'), get_locale_name()
            ),
            doc.resource.status = controls.get('status')
            rows = temporal.tappointment_rows
            for row in rows:
                if row.deleted and row.main_id:
                    DBSession.delete(row.main)
                elif row.main_id:
                    row.main.position_id = row.position_id
                    row.main.employee_id = row.employee_id
                else:
                    doc.rows.append(
                        AppointmentRow(
                            position_id=row.position_id,
                            employee_id=row.employee_id
                        )
                    )
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
        for id in self.request.params.getall('id'):
            appointment = Appointment.get(id)
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
        qb.union_temporal(
            self.request.params.get('tid'),
            self.request.params.get('appointment_id'),
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
        name='add_row',
        context='..resources.appointments.Appointments',
        request_method='GET',
        renderer='travelcrm:templates/appointments/form_row.mak',
        permission='add'
    )
    def add_row(self):
        return {'title': _(u'Add Row')}

    @view_config(
        name='add_row',
        context='..resources.appointments.Appointments',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add_row(self):
        schema = TAppointmentRowSchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params)
            temporal = Temporal.get(controls.get('tid'))
            row = TAppointmentRow(
                main_id=controls.get('main_id'),
                employee_id=controls.get('employee_id'),
                position_id=controls.get('position_id'),
            )
            temporal.tappointment_rows.append(row)
            return {'success_message': _(u'Saved')}
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit_row',
        context='..resources.appointments.Appointments',
        request_method='GET',
        renderer='travelcrm:templates/appointments/form_row.mak',
        permission='edit'
    )
    def edit_row(self):
        id = self.request.params.get('id')
        id = int(id)
        if id < 0:
            item = TAppointmentRow.get(abs(id))
        else:
            item = AppointmentRow.get(id)
        return {
            'item': item,
            'title': _(u'Edit Row')
        }

    @view_config(
        name='edit_row',
        context='..resources.appointments.Appointments',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit_row(self):
        id = int(self.request.params.get('id'))
        row = (
            TAppointmentRow.get(abs(id)) if id < 0 else AppointmentRow.get(id)
        )
        schema = TAppointmentRowSchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params)
            if isinstance(row, AppointmentRow):
                row = TAppointmentRow(
                    main_id=row.id
                )
                DBSession.add(row)
            row.employee_id = controls.get('employee_id')
            row.position_id = controls.get('position_id')
            row.temporal_id = controls.get('tid')
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
            'tid': self.request.params.get('tid'),
            'id': self.request.params.get('id')
        }

    @view_config(
        name='delete_row',
        context='..resources.appointments.Appointments',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete_row(self):
        for id in self.request.params.getall('id'):
            id = int(id)
            row = (
                TAppointmentRow.get(abs(id))
                if id < 0 else AppointmentRow.get(id)
            )
            if isinstance(row, AppointmentRow):
                row = TAppointmentRow(
                    main_id=row.id,
                    employee_id=row.employee_id,
                    position_id=row.position_id,
                    temporal_id=self.request.params.get('tid'),
                )
                DBSession.add(row)
            row.deleted = True
        return {'success_message': _(u'Deleted')}
