# -*-coding: utf-8-*-

import logging

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound

from ..models import DBSession
from ..models.account_item import AccountItem
from ..lib.utils.common_utils import translate as _
from ..forms.account_item import (
    AccountItemForm,
    AccountItemSearchForm
)


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.account_item.AccountItemResource',
)
class AccountItemView(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/account_item/index.mak',
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
        form = AccountItemSearchForm(self.request, self.context)
        form.validate()
        qb = form.submit()
        return qb.get_serialized()

    @view_config(
        name='view',
        request_method='GET',
        renderer='travelcrm:templates/account_item/form.mak',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            account_item = AccountItem.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': account_item.id}
                )
            )
        result = self.edit()
        result.update({
            'title': _(u"View Account Item"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        request_method='GET',
        renderer='travelcrm:templates/account_item/form.mak',
        permission='add'
    )
    def add(self):
        return {'title': _(u'Add Account Item')}

    @view_config(
        name='add',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        form = AccountItemForm(self.request)
        if form.validate():
            account_item = form.submit()
            DBSession.add(account_item)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': account_item.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='edit',
        request_method='GET',
        renderer='travelcrm:templates/account_item/form.mak',
        permission='edit'
    )
    def edit(self):
        account_item = AccountItem.get(self.request.params.get('id'))
        return {'item': account_item, 'title': _(u'Edit AccountItem')}

    @view_config(
        name='edit',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        account_item = AccountItem.get(self.request.params.get('id'))
        form = AccountItemForm(self.request)
        if form.validate():
            form.submit(account_item)
            return {
                'success_message': _(u'Saved'),
                'response': account_item.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='delete',
        request_method='GET',
        renderer='travelcrm:templates/account_item/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Accounts Items'),
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
            item = AccountItem.get(id)
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
