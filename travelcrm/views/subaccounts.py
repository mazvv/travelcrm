# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.subaccount import Subaccount
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.subaccounts import SubaccountsQueryBuilder
from ..lib.utils.common_utils import translate as _

from ..forms.subaccounts import SubaccountSchema


log = logging.getLogger(__name__)


class Subaccounts(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.subaccounts.Subaccounts',
        request_method='GET',
        renderer='travelcrm:templates/subaccounts/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.subaccounts.Subaccounts',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        qb = SubaccountsQueryBuilder(self.context)
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
        context='..resources.subaccounts.Subaccounts',
        request_method='GET',
        renderer='travelcrm:templates/subaccounts/form.mak',
        permission='view'
    )
    def view(self):
        result = self.edit()
        result.update({
            'title': _(u"View Subaccount"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        context='..resources.subaccounts.Subaccounts',
        request_method='GET',
        renderer='travelcrm:templates/subaccounts/form.mak',
        permission='add'
    )
    def add(self):
        return {'title': _(u'Add Subaccount')}

    @view_config(
        name='add',
        context='..resources.subaccounts.Subaccounts',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        schema = SubaccountSchema().bind(request=self.request)

        try:
            controls = schema.deserialize(self.request.params.mixed())
            subaccount = Subaccount(
                account_id=controls.get('account_id'),
                name=controls.get('name'),
                descr=controls.get('descr'),
                resource=self.context.create_resource()
            )
            for id in controls.get('note_id'):
                note = Note.get(id)
                subaccount.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                subaccount.resource.tasks.append(task)
            DBSession.add(subaccount)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': subaccount.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.subaccounts.Subaccounts',
        request_method='GET',
        renderer='travelcrm:templates/subaccounts/form.mak',
        permission='edit'
    )
    def edit(self):
        subaccount = Subaccount.get(self.request.params.get('id'))
        return {'item': subaccount, 'title': _(u'Edit Subaccount')}

    @view_config(
        name='edit',
        context='..resources.subaccounts.Subaccounts',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        schema = SubaccountSchema().bind(request=self.request)
        subaccount = Subaccount.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params.mixed())
            subaccount.account_id = controls.get('account_id')
            subaccount.name = controls.get('name')
            subaccount.descr = controls.get('descr')
            subaccount.resource.notes = []
            subaccount.resource.tasks = []
            for id in controls.get('note_id'):
                note = Note.get(id)
                subaccount.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                subaccount.resource.tasks.append(task)
            return {
                'success_message': _(u'Saved'),
                'response': subaccount.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='delete',
        context='..resources.subaccounts.Subaccounts',
        request_method='GET',
        renderer='travelcrm:templates/subaccounts/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Subaccounts'),
            'rid': self.request.params.get('rid')
        }

    @view_config(
        name='delete',
        context='..resources.subaccounts.Subaccounts',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        errors = 0
        for id in self.request.params.getall('id'):
            item = Subaccount.get(id)
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
