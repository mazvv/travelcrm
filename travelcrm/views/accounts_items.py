# -*-coding: utf-8-*-

import logging

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound

from . import BaseView
from ..models import DBSession
from ..models.account_item import AccountItem
from ..lib.bl.subscriptions import subscribe_resource
from ..lib.utils.common_utils import translate as _
from ..forms.accounts_items import (
    AccountItemForm,
    AccountItemSearchForm
)
from ..lib.events.resources import (
    ResourceCreated,
    ResourceChanged,
    ResourceDeleted,
)


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.accounts_items.AccountsItemsResource',
)
class AccountsItemsView(BaseView):

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/accounts_items/index.mako',
        permission='view'
    )
    def index(self):
        return {
            'title': self._get_title(),
        }

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
        renderer='travelcrm:templates/accounts_items/form.mako',
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
            'title': self._get_title(_(u'View')),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        request_method='GET',
        renderer='travelcrm:templates/accounts_items/form.mako',
        permission='add'
    )
    def add(self):
        return {
            'title': self._get_title(_(u'Add')),
        }

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
            event = ResourceCreated(self.request, account_item)
            event.registry()
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
        renderer='travelcrm:templates/accounts_items/form.mako',
        permission='edit'
    )
    def edit(self):
        account_item = AccountItem.get(self.request.params.get('id'))
        return {
            'item': account_item, 
            'title': self._get_title(_(u'Edit')),
        }

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
            event = ResourceChanged(self.request, account_item)
            event.registry()
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
        name='copy',
        request_method='GET',
        renderer='travelcrm:templates/accounts_items/form.mako',
        permission='add'
    )
    def copy(self):
        account_item = AccountItem.get_copy(self.request.params.get('id'))
        return {
            'action': self.request.path_url,
            'item': account_item,
            'title': self._get_title(_(u'Copy')),
        }

    @view_config(
        name='copy',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _copy(self):
        return self._add()

    @view_config(
        name='delete',
        request_method='GET',
        renderer='travelcrm:templates/accounts_items/delete.mako',
        permission='delete'
    )
    def delete(self):
        return {
            'title': self._get_title(_(u'Delete')),
            'rid': self.request.params.get('rid')
        }

    @view_config(
        name='delete',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        errors = False
        ids = self.request.params.getall('id')
        if ids:
            try:
                items = DBSession.query(AccountItem).filter(
                    AccountItem.id.in_(ids)
                )
                for item in items:
                    DBSession.delete(item)
                    event = ResourceDeleted(self.request, item)
                    event.registry()
                DBSession.flush()
            except:
                errors=True
                DBSession.rollback()
        if errors:
            return {
                'error_message': _(
                    u'Some objects could not be delete'
                ),
            }
        return {'success_message': _(u'Deleted')}

    @view_config(
        name='subscribe',
        request_method='GET',
        renderer='travelcrm:templates/accounts_items/subscribe.mako',
        permission='view'
    )
    def subscribe(self):
        return {
            'id': self.request.params.get('id'),
            'title': self._get_title(_(u'Subscribe')),
        }

    @view_config(
        name='subscribe',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def _subscribe(self):
        ids = self.request.params.getall('id')
        for id in ids:
            account_item = AccountItem.get(id)
            subscribe_resource(self.request, account_item.resource)
        return {
            'success_message': _(u'Subscribed'),
        }
