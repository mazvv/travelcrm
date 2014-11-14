# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.outgoing import Outgoing
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.outgoings import OutgoingsQueryBuilder
from ..lib.bl.employees import get_employee_structure
from ..lib.bl.outgoings import make_payment
from ..lib.utils.security_utils import get_auth_employee
from ..lib.utils.common_utils import translate as _

from travelcrm.forms.outgoings import OutgoingSchema


log = logging.getLogger(__name__)


class Outgoings(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.outgoings.Outgoings',
        request_method='GET',
        renderer='travelcrm:templates/outgoings/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.outgoings.Outgoings',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        qb = OutgoingsQueryBuilder(self.context)
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
        context='..resources.outgoings.Outgoings',
        request_method='GET',
        renderer='travelcrm:templates/outgoings/form.mak',
        permission='view'
    )
    def view(self):
        result = self.edit()
        result.update({
            'title': _(u"View Outgoing"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        context='..resources.outgoings.Outgoings',
        request_method='GET',
        renderer='travelcrm:templates/outgoings/form.mak',
        permission='add'
    )
    def add(self):
        auth_employee = get_auth_employee(self.request)
        structure = get_employee_structure(auth_employee)
        return {
            'title': _(u'Add Outgoing'),
            'structure_id': structure.id
        }

    @view_config(
        name='add',
        context='..resources.outgoings.Outgoings',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        schema = OutgoingSchema().bind(request=self.request)

        try:
            controls = schema.deserialize(self.request.params.mixed())
            outgoing = Outgoing(
                date=controls.get('date'),
                account_id=controls.get('account_id'),
                account_item_id=controls.get('account_item_id'),
                subaccount_id=controls.get('subaccount_id'),
                sum=controls.get('sum'),
                resource=self.context.create_resource()
            )
            outgoing.transfers = make_payment(
                controls.get('date'),
                controls.get('account_item_id'),
                controls.get('sum'),
            )
            for id in controls.get('note_id'):
                note = Note.get(id)
                outgoing.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                outgoing.resource.tasks.append(task)
            DBSession.add(outgoing)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': outgoing.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.outgoings.Outgoings',
        request_method='GET',
        renderer='travelcrm:templates/outgoings/form.mak',
        permission='edit'
    )
    def edit(self):
        outgoing = Outgoing.get(self.request.params.get('id'))
        structure_id = outgoing.resource.owner_structure.id
        return {
            'item': outgoing,
            'structure_id': structure_id,
            'title': _(u'Edit Outgoing'),
        }

    @view_config(
        name='edit',
        context='..resources.outgoings.Outgoings',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        schema = OutgoingSchema().bind(request=self.request)
        outgoing = Outgoing.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params.mixed())
            outgoing.rollback()
            outgoing.date = controls.get('date')
            outgoing.account_id = controls.get('account_id')
            outgoing.account_item_id = controls.get('account_item_id')
            outgoing.subaccount_id = controls.get('subaccount_id')
            outgoing.sum = controls.get('sum')
            outgoing.transfers = make_payment(
                controls.get('date'),
                controls.get('account_item_id'),
                controls.get('sum'),
            )
            outgoing.resource.notes = []
            outgoing.resource.tasks = []
            for id in controls.get('note_id'):
                note = Note.get(id)
                outgoing.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                outgoing.resource.tasks.append(task)
            return {
                'success_message': _(u'Saved'),
                'response': outgoing.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='delete',
        context='..resources.outgoings.Outgoings',
        request_method='GET',
        renderer='travelcrm:templates/outgoings/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Outgoing Payments'),
            'rid': self.request.params.get('rid')
        }

    @view_config(
        name='delete',
        context='..resources.outgoings.Outgoings',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        errors = 0
        for id in self.request.params.getall('id'):
            item = Outgoing.get(id)
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
