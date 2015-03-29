# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound

from ..models import DBSession
from ..models.crosspayment import Crosspayment
from ..models.transfer import Transfer
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.crosspayment import CrosspaymentQueryBuilder
from ..lib.utils.common_utils import translate as _

from ..forms.crosspayment import (
    CrosspaymentSchema, 
    CrosspaymentSearchSchema
)


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.crosspayment.CrosspaymentResource',
)
class CrosspaymentView(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/crosspayments/index.mak',
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
        schema = CrosspaymentSearchSchema().bind(request=self.request)
        controls = schema.deserialize(self.request.params.mixed())
        qb = CrosspaymentQueryBuilder(self.context)
        qb.search_simple(controls.get('q'))
        qb.advanced_search(**controls)
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
        request_method='GET',
        renderer='travelcrm:templates/crosspayments/form.mak',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            crosspayment = Crosspayment.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': crosspayment.id}
                )
            )
        result = self.edit()
        result.update({
            'title': _(u"View Crosspayment"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        request_method='GET',
        renderer='travelcrm:templates/crosspayments/form.mak',
        permission='add'
    )
    def add(self):
        return {'title': _(u'Add Crosspayment')}

    @view_config(
        name='add',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        schema = CrosspaymentSchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params.mixed())
            crosspayment = Crosspayment(
                descr=controls.get('descr'),
                resource=self.context.create_resource()
            )
            transfer = Transfer(
                date=controls.get('date'),
                account_from_id=controls.get('account_from_id'),
                account_to_id=controls.get('account_to_id'),
                subaccount_from_id=controls.get('subaccount_from_id'),
                subaccount_to_id=controls.get('subaccount_to_id'),
                account_item_id=controls.get('account_item_id'),
                sum=controls.get('sum'),
            )
            crosspayment.transfer = transfer
            for id in controls.get('note_id'):
                note = Note.get(id)
                crosspayment.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                crosspayment.resource.tasks.append(task)
            DBSession.add(crosspayment)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': crosspayment.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        request_method='GET',
        renderer='travelcrm:templates/crosspayments/form.mak',
        permission='edit'
    )
    def edit(self):
        crosspayment = Crosspayment.get(self.request.params.get('id'))
        return {'item': crosspayment, 'title': _(u'Edit Crosspayment')}

    @view_config(
        name='edit',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        schema = CrosspaymentSchema().bind(request=self.request)
        crosspayment = Crosspayment.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params.mixed())
            crosspayment.descr = controls.get('descr')
            transfer = crosspayment.transfer
            transfer.date = controls.get('date')
            transfer.account_from_id = controls.get('account_from_id')
            transfer.account_to_id = controls.get('account_to_id')
            transfer.account_item_id = controls.get('account_item_id')
            transfer.subaccount_to_id = controls.get('subaccount_to_id')
            transfer.subaccount_item_id = controls.get('subaccount_item_id')
            transfer.sum = controls.get('sum')
            crosspayment.transfer = transfer
            crosspayment.resource.notes = []
            crosspayment.resource.tasks = []
            for id in controls.get('note_id'):
                note = Note.get(id)
                crosspayment.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                crosspayment.resource.tasks.append(task)
            return {
                'success_message': _(u'Saved'),
                'response': crosspayment.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='delete',
        request_method='GET',
        renderer='travelcrm:templates/crosspayments/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Crosspayments'),
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
            item = Crosspayment.get(id)
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
