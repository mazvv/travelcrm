# -*-coding: utf-8-*-

import logging
from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound

from . import BaseView
from ..models import DBSession
from ..models.position import Position
from ..models.navigation import Navigation
from ..lib.bl.subscriptions import subscribe_resource
from ..lib.utils.common_utils import translate as _
from ..forms.navigations import (
    NavigationForm,
    NavigationSearchForm,
    NavigationAssignForm,
    NavigationCopyForm,
)
from ..lib.events.resources import (
    ResourceCreated,
    ResourceChanged,
    ResourceDeleted,
)


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.navigations.NavigationsResource',
)
class NavigationsView(BaseView):

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/navigations/index.mako',
        permission='view'
    )
    def index(self):
        position = Position.get(self.request.params.get('id'))
        return {
            'position': position,
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
        form = NavigationSearchForm(self.request, self.context)
        form.validate()
        qb = form.submit()
        return qb.get_serialized()

    @view_config(
        name='view',
        request_method='GET',
        renderer='travelcrm:templates/navigations/form.mako',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            navigation = Navigation.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': navigation.id}
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
        renderer='travelcrm:templates/navigations/form.mako',
        permission='add'
    )
    def add(self):
        position = Position.get(
            self.request.params.get('position_id')
        )
        return {
            'position': position,
            'title': self._get_title(_(u'Add')),
        }

    @view_config(
        name='add',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        form = NavigationForm(self.request)
        if form.validate():
            navigation = form.submit()
            DBSession.add(navigation)
            event = ResourceCreated(self.request, navigation)
            event.registry()
            return {'success_message': _(u'Saved')}
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='edit',
        request_method='GET',
        renderer='travelcrm:templates/navigations/form.mako',
        permission='edit'
    )
    def edit(self):
        navigation = Navigation.get(
            self.request.params.get('id')
        )
        position = navigation.position
        return {
            'title': self._get_title(_(u'Edit')),
            'position': position,
            'item': navigation
        }

    @view_config(
        name='edit',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        navigation = Navigation.get(self.request.params.get('id'))
        form = NavigationForm(self.request)
        if form.validate():
            form.submit(navigation)
            event = ResourceChanged(self.request, navigation)
            event.registry()
            return {'success_message': _(u'Saved')}
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='delete',
        request_method='GET',
        renderer='travelcrm:templates/navigations/delete.mako',
        permission='delete'
    )
    def delete(self):
        return {
            'title': self._get_title(_(u'Delete')),
            'id': self.request.params.get('id')
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
                items = DBSession.query(Navigation).filter(
                    Navigation.id.in_(ids)
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
        renderer='travelcrm:templates/navigations/assign.mako',
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
        form = NavigationAssignForm(self.request)
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
        name='up',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _up(self):
        navigation = Navigation.get(
            self.request.params.get('id')
        )
        if navigation:
            navigation.change_sort_order('up')

    @view_config(
        name='down',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _down(self):
        navigation = Navigation.get(
            self.request.params.get('id')
        )
        if navigation:
            navigation.change_sort_order('down')

    @view_config(
        name='copy',
        request_method='GET',
        renderer='travelcrm:templates/navigations/copy.mako',
        permission='edit'
    )
    def copy(self):
        position = Position.get(self.request.params.get('position_id'))
        return {
            'action': self.request.path_url,
            'position': position,
            'title': self._get_title(_(u'Copy')),
        }

    @view_config(
        name='copy',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _copy(self):
        form = NavigationCopyForm(self.request)
        if form.validate():
            form.submit()
            return {'success_message': _(u'Copied')}
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='subscribe',
        request_method='GET',
        renderer='travelcrm:templates/navigations/subscribe.mako',
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
            navigation = Navigation.get(id)
            subscribe_resource(self.request, navigation.resource)
        return {
            'success_message': _(u'Subscribed'),
        }
