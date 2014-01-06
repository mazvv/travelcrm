# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.resource_type import ResourceType
from ..models.resource import Resource

from ..forms.resources_types import (
    AddForm,
    EditForm
)


log = logging.getLogger(__name__)


class ResourcesTypes(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.resources_types.ResourcesTypes',
        request_method='GET',
        renderer='travelcrm:templates/resources_types#index.pt',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.resources_types.ResourcesTypes',
        permission='view',
        xhr='True',
        request_method='POST',
        renderer='json'
    )
    def list(self):
        sort = self.request.params.get('sort')
        order = self.request.params.get('order', 'asc')
        page = self.request.params.get('page')
        rows = self.request.params.get('rows')
        return self.context.get_json_page(sort, order, page, rows)

    @view_config(
        name='add',
        context='..resources.resources_types.ResourceType',
        request_method='GET',
        renderer='travelcrm:templates/resources_types#form.pt',
        permission='add'
    )
    def add(self):
        return {}

    @view_config(
        name="add",
        context="..resources.resources_types.ResourceType",
        request_method="POST",
        renderer='json',
        permission="add"
    )
    def _add(self):
        schema = AddForm().bind(request=self.request)
        _ = self.request.translate
        try:
            controls = schema.deserialize(self.request.params)
            resource_type = ResourceType(
                humanize=controls.get('humanize'),
                name=controls.get('name'),
                resource=controls.get('resource'),
                description=controls.get('description'),
                resource_obj=self.context.create_resource(
                    controls.get('status')
                )
            )
            DBSession.add(resource_type)
            return {'success_message': _(u'Saved')}
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.resources_types.ResourceType',
        request_method='GET',
        renderer='travelcrm:templates/resources_types#form.pt',
        permission='edit'
    )
    def edit(self):
        _ = self.request.translate
        resource = Resource.by_rid(self.request.params.get('rid'))
        return {
            'item': resource.resource_type_obj,
            'title': _(u"Edit Resource Type")
        }

    @view_config(
        name="edit",
        context="..resources.resources_types.ResourceType",
        request_method="POST",
        renderer='json',
        permission="edit"
    )
    def _edit(self):
        _ = self.request.translate
        schema = EditForm().bind(request=self.request)
        resource = Resource.by_rid(self.request.params.get('rid'))
        resource_type = resource.resource_type_obj
        try:
            controls = schema.deserialize(self.request.params)
            resource_type.humanize = controls.get('humanize')
            resource_type.name = controls.get('name')
            resource_type.resource = controls.get('resource')
            resource_type.description = controls.get('description')
            resource_type.resource_obj.status = controls.get('status')
            return {'success_message': _(u'Saved')}
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='copy',
        context='..resources.resources_types.ResourceType',
        request_method='GET',
        renderer='travelcrm:templates/resources_types#form.pt',
        permission='add'
    )
    def copy(self):
        _ = self.request.translate
        resource = Resource.by_rid(self.request.params.get('rid'))
        return {
            'item': resource.resource_type_obj,
            'title': _(u"Copy Resource Type")
        }

    @view_config(
        name='copy',
        context='..resources.resources_types.ResourceType',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _copy(self):
        return self._add()

    @view_config(
        name='delete',
        context='..resources.resources_types.ResourcesTypes',
        request_method='GET',
        renderer='travelcrm:templates/resources_types#delete.pt',
        permission='delete'
    )
    def delete(self):
        return {
            'rid': self.request.params.get('rid')
        }

    @view_config(
        name="delete",
        context="..resources.resources_types.ResourcesTypes",
        request_method="POST",
        renderer='json',
        permission="delete"
    )
    def _delete(self):
        _ = self.request.translate
        for rid in self.request.params.getall('rid'):
            resource = Resource.by_rid(rid)
            if resource:
                DBSession.delete(resource)
        return {'success_message': _(u'Deleted')}


    @view_config(
        name="combobox",
        context="..resources.resources_types.ResourcesTypes",
        request_method="POST",
        renderer='json',
        permission="view"
    )
    def _combobox(self):
        items = (
            DBSession.query(
                ResourceType.rid,
                ResourceType.humanize
            )
            .order_by(ResourceType.humanize)
        )
        return [
            {'rid': item.rid, 'name': item.humanize}
            for item in items
        ]
