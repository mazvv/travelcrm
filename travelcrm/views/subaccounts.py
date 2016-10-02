# -*-coding: utf-8-*-

import logging

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound

from . import BaseView
from ..models import DBSession
from ..models.subaccount import Subaccount
from ..lib.bl.subscriptions import subscribe_resource
from ..lib.utils.common_utils import translate as _
from ..lib.bl.subaccounts import get_bound_resource_by_subaccount_id
from ..forms.subaccounts import (
    SubaccountForm, 
    SubaccountSearchForm,
    SubaccountAssignForm,
)
from ..lib.events.resources import (
    ResourceCreated,
    ResourceChanged,
    ResourceDeleted,
)


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.subaccounts.SubaccountsResource',
)
class SubaccountsView(BaseView):

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/subaccounts/index.mako',
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
        form = SubaccountSearchForm(self.request, self.context)
        form.validate()
        qb = form.submit()
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized()
        }

    @view_config(
        name='view',
        request_method='GET',
        renderer='travelcrm:templates/subaccounts/form.mako',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            subaccount = Subaccount.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': subaccount.id}
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
        renderer='travelcrm:templates/subaccounts/form.mako',
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
        form = SubaccountForm(self.request)
        if form.validate():
            subaccount, source = form.submit()
            DBSession.add(source)
            DBSession.flush()
            event = ResourceCreated(self.request, subaccount)
            event.registry()
            return {
                'success_message': _(u'Saved'),
                'response': subaccount.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='edit',
        request_method='GET',
        renderer='travelcrm:templates/subaccounts/form.mako',
        permission='edit'
    )
    def edit(self):
        subaccount = Subaccount.get(self.request.params.get('id'))
        resource = get_bound_resource_by_subaccount_id(subaccount.id)
        return {
            'item': subaccount,
            'resource': resource,
            'title': self._get_title(_(u'Edit')),
        }

    @view_config(
        name='edit',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        subaccount = Subaccount.get(self.request.params.get('id'))
        form = SubaccountForm(self.request)
        if form.validate():
            form.submit(subaccount)
            event = ResourceChanged(self.request, subaccount)
            event.registry()
            return {
                'success_message': _(u'Saved'),
                'response': subaccount.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='copy',
        request_method='GET',
        renderer='travelcrm:templates/subaccounts/form.mako',
        permission='add'
    )
    def copy(self):
        subaccount = Subaccount.get_copy(self.request.params.get('id'))
        resource = get_bound_resource_by_subaccount_id(
            self.request.params.get('id')
        )
        return {
            'action': self.request.path_url,
            'item': subaccount,
            'resource': resource,
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
        name='details',
        request_method='GET',
        renderer='travelcrm:templates/subaccounts/details.mako',
        permission='view'
    )
    def details(self):
        subaccount = Subaccount.get(self.request.params.get('id'))
        return {
            'item': subaccount,
        }


    @view_config(
        name='delete',
        request_method='GET',
        renderer='travelcrm:templates/subaccounts/delete.mako',
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
                items = DBSession.query(Subaccount).filter(
                    Subaccount.id.in_(ids)
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
        name='assign',
        request_method='GET',
        renderer='travelcrm:templates/subaccounts/assign.mako',
        permission='assign'
    )
    def assign(self):
        return {
            'id': self.request.params.get('id'),
            'title': self._get_title(_(u'Assign Maintainer')),
        }

    @view_config(
        name='assign',
        request_method='POST',
        renderer='json',
        permission='assign'
    )
    def _assign(self):
        form = SubaccountAssignForm(self.request)
        if form.validate():
            form.submit(self.request.params.getall('id'))
            return {
                'success_message': _(u'Assigned'),
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='subscribe',
        request_method='GET',
        renderer='travelcrm:templates/subaccounts/subscribe.mako',
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
            subaccount = Subaccount.get(id)
            subscribe_resource(self.request, subaccount.resource)
        return {
            'success_message': _(u'Subscribed'),
        }
