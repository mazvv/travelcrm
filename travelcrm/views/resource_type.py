# -*-coding: utf-8-*-

import logging

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound

from ..models import DBSession
from ..models.resource_type import ResourceType
from ..lib.utils.common_utils import translate as _
from ..lib.utils.resources_utils import get_resource_class

from ..forms.resource_type import (
    ResourceTypeForm, 
    ResourceTypeSearchForm
)


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.resource_type.ResourceTypeResource',
)
class ResourceTypeView(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/resource_type/index.mak',
        permission='view'
    )
    def index(self):
        return {}

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
        renderer='travelcrm:templates/resource_type/form.mak',
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
            'title': _(u"View Resource Type"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        request_method='GET',
        renderer='travelcrm:templates/resource_type/form.mak',
        permission='add'
    )
    def add(self):
        return {
            'title': _(u"Add Resource Type")
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
        renderer='travelcrm:templates/resource_type/form.mak',
        permission='edit'
    )
    def edit(self):
        resources_type = ResourceType.get(self.request.params.get('id'))
        return {
            'item': resources_type,
            'title': _(u"Edit Resource Type")
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
        renderer='travelcrm:templates/resource_type/form.mak',
        permission='add'
    )
    def copy(self):
        resources_type = ResourceType.get(self.request.params.get('id'))
        return {
            'item': resources_type,
            'title': _(u"Copy Resource Type")
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
        renderer='travelcrm:templates/resource_type/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Resources Types'),
            'id': self.request.params.get('id')
        }

    @view_config(
        name="delete",
        request_method="POST",
        renderer='json',
        permission="delete"
    )
    def _delete(self):
        errors = 0
        for id in self.request.params.getall('id'):
            item = ResourceType.get(id)
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

    @view_config(
        name='settings',
        request_method='GET',
        renderer='travelcrm:templates/resource_type/settings.mak',
        permission='settings'
    )
    def settings(self):
        id = self.request.params.get('id')
        rt = ResourceType.get(id)
        if rt.customizable:
            rt_ctx = get_resource_class(rt.name)
            return HTTPFound(
                location=self.request.resource_url(
                    rt_ctx(self.request), 'settings'
                )
            )
        return {
            'title': _(u'Not Allowed')
        }
