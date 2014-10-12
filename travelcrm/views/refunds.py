# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.refund import Refund
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.refunds import RefundsQueryBuilder
from ..lib.bl.employees import get_employee_structure
from ..lib.utils.security_utils import get_auth_employee
from ..lib.utils.common_utils import translate as _
from ..lib.utils.resources_utils import get_resource_type_by_resource

from ..forms.refunds import RefundSchema, SettingsSchema


log = logging.getLogger(__name__)


class Refunds(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.refunds.Refunds',
        request_method='GET',
        renderer='travelcrm:templates/refunds/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.refunds.Refunds',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        qb = RefundsQueryBuilder(self.context)
        qb.search_simple(
            self.request.params.get('q'),
        )
        qb.advanced_search(
            **self.request.params.mixed()
        )
        id = self.request.params.get('id')
        if id:
            qb.filter_id(id.split(','))
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
        context='..resources.refunds.Refunds',
        request_method='GET',
        renderer='travelcrm:templates/refunds/form.mak',
        permission='view'
    )
    def view(self):
        result = self.edit()
        result.update({
            'title': _(u"View Refund"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        context='..resources.refunds.Refunds',
        request_method='GET',
        renderer='travelcrm:templates/refunds/form.mak',
        permission='add'
    )
    def add(self):
        auth_employee = get_auth_employee(self.request)
        structure = get_employee_structure(auth_employee)
        return {
            'title': _(u'Add Refund'),
            'structure_id': structure.id
        }

    @view_config(
        name='add',
        context='..resources.refunds.Refunds',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        schema = RefundSchema().bind(request=self.request)

        try:
            controls = schema.deserialize(self.request.params.mixed())
            refund = Refund(
                invoice_id=controls.get('invoice_id'),
                resource=self.context.create_resource(),
            )
            factory = self.context.get_outgoing_factory()
            refund.transactions = [
                factory.make_payment(
                    controls.get('date'), controls.get('sum')
                ),
            ]
            for id in controls.get('note_id'):
                note = Note.get(id)
                refund.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                refund.resource.tasks.append(task)
            DBSession.add(refund)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': refund.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.refunds.Refunds',
        request_method='GET',
        renderer='travelcrm:templates/refunds/form.mak',
        permission='edit'
    )
    def edit(self):
        refund = Refund.get(self.request.params.get('id'))
        return {'item': refund, 'title': _(u'Edit Refund')}

    @view_config(
        name='edit',
        context='..resources.refunds.Refunds',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        schema = RefundSchema().bind(request=self.request)
        refund = Refund.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params.mixed())
            refund.invoice_id = controls.get('invoice_id')
            refund.rollback()
            factory = self.context.get_outgoing_factory()
            refund.transactions = [
                factory.make_payment(
                    controls.get('date'), controls.get('sum')
                ),
            ]
            refund.resource.notes = []
            refund.resource.tasks = []
            for id in controls.get('note_id'):
                note = Note.get(id)
                refund.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                refund.resource.tasks.append(task)
            return {
                'success_message': _(u'Saved'),
                'response': refund.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='delete',
        context='..resources.refunds.Refunds',
        request_method='GET',
        renderer='travelcrm:templates/refunds/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Refund Payments'),
            'rid': self.request.params.get('rid')
        }

    @view_config(
        name='delete',
        context='..resources.refunds.Refunds',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        errors = 0
        for id in self.request.params.getall('id'):
            item = Refund.get(id)
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

    @view_config(
        name='settings',
        context='..resources.refunds.Refunds',
        request_method='GET',
        renderer='travelcrm:templates/refunds/settings.mak',
        permission='settings',
    )
    def settings(self):
        rt = get_resource_type_by_resource(self.context)
        return {
            'title': _(u'Settings'),
            'rt': rt,
        }

    @view_config(
        name='settings',
        context='..resources.refunds.Refunds',
        request_method='POST',
        renderer='json',
        permission='settings',
    )
    def _settings(self):
        schema = SettingsSchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params)
            rt = get_resource_type_by_resource(self.context)
            rt.settings = {'account_item_id': controls.get('account_item_id')}
            return {'success_message': _(u'Saved')}
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }
