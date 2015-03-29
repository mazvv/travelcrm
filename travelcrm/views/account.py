# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound

from ..models import DBSession
from ..models.account import Account
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.account import AccountQueryBuilder
from ..lib.utils.common_utils import translate as _
from ..forms.account import (
    AccountSchema, 
    AccountSearchSchema
)


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.account.AccountResource',
)
class AccountView(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/accounts/index.mak',
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
        schema = AccountSearchSchema().bind(request=self.request)
        controls = schema.deserialize(self.request.params.mixed())
        qb = AccountQueryBuilder(self.context)
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
        renderer='travelcrm:templates/accounts/form.mak',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            account = Account.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': account.id}
                )
            )
        result = self.edit()
        result.update({
            'title': _(u"View Account"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        request_method='GET',
        renderer='travelcrm:templates/accounts/form.mak',
        permission='add'
    )
    def add(self):
        return {'title': _(u'Add Account')}

    @view_config(
        name='add',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        schema = AccountSchema().bind(request=self.request)

        try:
            controls = schema.deserialize(self.request.params.mixed())
            account = Account(
                name=controls.get('name'),
                currency_id=controls.get('currency_id'),
                account_type=controls.get('account_type'),
                display_text=controls.get('display_text'),
                descr=controls.get('descr'),
                resource=self.context.create_resource()
            )
            for id in controls.get('note_id'):
                note = Note.get(id)
                account.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                account.resource.tasks.append(task)
            DBSession.add(account)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': account.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        request_method='GET',
        renderer='travelcrm:templates/accounts/form.mak',
        permission='edit'
    )
    def edit(self):
        account = Account.get(self.request.params.get('id'))
        return {'item': account, 'title': _(u'Edit Account')}

    @view_config(
        name='edit',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        schema = AccountSchema().bind(request=self.request)
        account = Account.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params.mixed())
            account.name = controls.get('name')
            account.currency_id = controls.get('currency_id')
            account.account_type = controls.get('account_type')
            account.display_text = controls.get('display_text')
            account.descr = controls.get('descr')
            account.resource.notes = []
            account.resource.tasks = []
            for id in controls.get('note_id'):
                note = Note.get(id)
                account.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                account.resource.tasks.append(task)
            return {
                'success_message': _(u'Saved'),
                'response': account.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='delete',
        request_method='GET',
        renderer='travelcrm:templates/accounts/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Accounts'),
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
            item = Account.get(id)
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
