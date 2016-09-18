# -*-coding: utf-8-*-

import logging

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound

from . import BaseView
from ..models import DBSession
from ..models.resource_type import ResourceType
from ..lib.bl.subscriptions import subscribe_resource
from ..lib.utils.common_utils import translate as _
from ..lib.utils.resources_utils import get_resource_class

from ..forms.resources_types import (
    ResourceTypeForm, 
    ResourceTypeSearchForm,
    ResourceTypeAssignForm,
)


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.resources_types.ResourcesTypesResource',
)
class ResourcesTypesView(BaseView):

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/resources_types/index.mako',
        permission='view'
    )
    def index(self):
        return {
            'title': self._get_title(),
        }

    @view_config(
        name='list',
        permission='view',
        xhr='True',
        request_method='POST',
        renderer='json'
    )
    def list(self):
        form = ResourceTypeSearchForm(self.request, self.context)
        form.validate()
        qb = form.submit()
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized()
        }

    @view_config(
        name='view',
        request_method='GET',
        renderer='travelcrm:templates/resources_types/form.mako',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            resource_type= ResourceType.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': resource_type.id}
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
        renderer='travelcrm:templates/resources_types/form.mako',
        permission='add'
    )
    def add(self):
        return {
            'title': self._get_title(_(u'Add')),
        }

    @view_config(
        name="add",
        request_method="POST",
        renderer='json',
        permission="add"
    )
    def _add(self):
        form = ResourceTypeForm(self.request)
        if form.validate():
            resource_type = form.submit()
            DBSession.add(resource_type)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': resource_type.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='edit',
        request_method='GET',
        renderer='travelcrm:templates/resources_types/form.mako',
        permission='edit'
    )
    def edit(self):
        resources_type = ResourceType.get(self.request.params.get('id'))
        return {
            'item': resources_type,
            'title': self._get_title(_(u'Edit')),
        }

    @view_config(
        name="edit",
        request_method="POST",
        renderer='json',
        permission="edit"
    )
    def _edit(self):
        resource_type = ResourceType.get(self.request.params.get('id'))
        form = ResourceTypeForm(self.request)
        if form.validate():
            form.submit(resource_type)
            return {
                'success_message': _(u'Saved'),
                'response': resource_type.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='copy',
        request_method='GET',
        renderer='travelcrm:templates/resources_types/form.mako',
        permission='add'
    )
    def copy(self):
        resources_type = ResourceType.get_copy(self.request.params.get('id'))
        return {
            'action': self.request.path_url,
            'item': resources_type,
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
        renderer='travelcrm:templates/resources_types/details.mako',
        permission='view'
    )
    def details(self):
        rt = ResourceType.get(self.request.params.get('id'))
        rt_ctx = get_resource_class(rt.name)
        rt_ctx = rt_ctx(self.request)
        return {
            'item': rt,
            'rt_ctx': rt_ctx
        }

    @view_config(
        name='delete',
        request_method='GET',
        renderer='travelcrm:templates/resources_types/delete.mako',
        permission='delete'
    )
    def delete(self):
        return {
            'title': self._get_title(_(u'Delete')),
            'id': self.request.params.get('id')
        }

    @view_config(
        name="delete",
        request_method="POST",
        renderer='json',
        permission="delete"
    )
    def _delete(self):
        errors = False
        ids = self.request.params.getall('id')
        if ids:
            try:
                items = DBSession.query(ResourceType).filter(
                    ResourceType.id.in_(ids)
                )
                for item in items:
                    DBSession.delete(item)
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
        renderer='travelcrm:templates/resources_types/assign.mako',
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
        form = ResourceTypeAssignForm(self.request)
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
        name='settings',
        request_method='GET',
        renderer='travelcrm:templates/resources_types/settings.mako',
        permission='settings'
    )
    def settings(self):
        id = self.request.params.get('id')
        rt = ResourceType.get(id)
        rt_ctx = get_resource_class(rt.name)
        rt_ctx = rt_ctx(self.request)
        if getattr(rt_ctx, 'allowed_settings', False):
            return HTTPFound(
                location=self.request.resource_url(rt_ctx, 'settings')
            )
        return {
            'title': _(u'Not Allowed')
        }

    @view_config(
        name='subscribe',
        request_method='GET',
        renderer='travelcrm:templates/resources_types/subscribe.mako',
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
            resource_type = ResourceType.get(id)
            subscribe_resource(self.request, resource_type.resource_obj)
        return {
            'success_message': _(u'Subscribed'),
        }
