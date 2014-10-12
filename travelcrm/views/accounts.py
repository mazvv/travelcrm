# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.account import Account
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.accounts import AccountsQueryBuilder
from ..lib.utils.common_utils import translate as _

from ..forms.accounts import AccountSchema


log = logging.getLogger(__name__)


class Accounts(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.accounts.Accounts',
        request_method='GET',
        renderer='travelcrm:templates/accounts/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.accounts.Accounts',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        qb = AccountsQueryBuilder(self.context)
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
        context='..resources.accounts.Accounts',
        request_method='GET',
        renderer='travelcrm:templates/accounts/form.mak',
        permission='view'
    )
    def view(self):
        result = self.edit()
        result.update({
            'title': _(u"View Account"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        context='..resources.accounts.Accounts',
        request_method='GET',
        renderer='travelcrm:templates/accounts/form.mak',
        permission='add'
    )
    def add(self):
        return {'title': _(u'Add Account')}

    @view_config(
        name='add',
        context='..resources.accounts.Accounts',
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
        context='..resources.accounts.Accounts',
        request_method='GET',
        renderer='travelcrm:templates/accounts/form.mak',
        permission='edit'
    )
    def edit(self):
        account = Account.get(self.request.params.get('id'))
        return {'item': account, 'title': _(u'Edit Account')}

    @view_config(
        name='edit',
        context='..resources.accounts.Accounts',
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
        context='..resources.accounts.Accounts',
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
        context='..resources.accounts.Accounts',
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
