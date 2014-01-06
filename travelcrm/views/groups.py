# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.group import Group
from ..models.group_permission import GroupPermision
from ..models.resource import Resource

from ..forms.groups import (
    AddForm,
    EditForm,
    PermissionsForm,
)


log = logging.getLogger(__name__)


class Groups(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.groups.Groups',
        request_method='GET',
        renderer='travelcrm:templates/groups#index.pt',
        layout='main_layout',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.groups.Groups',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        sort = self.request.params.get('sort')
        order = self.request.params.get('order', 'asc')
        page = self.request.params.get('page')
        rows = self.request.params.get('rows')
        return self.context.get_json_page(sort, order, page, rows)

    @view_config(
        name='add',
        context='..resources.groups.Group',
        request_method='GET',
        renderer='travelcrm:templates/groups#form.pt',
        permission='add'
    )
    def add(self):
        return {}

    @view_config(
        name='add',
        context='..resources.groups.Group',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        _ = self.request.translate
        schema = AddForm().bind(request=self.request)

        try:
            controls = schema.deserialize(self.request.params)
            group = Group(
                name=controls.get('name'),
                resource=self.context.create_resource(controls.get('status'))
            )
            DBSession.add(group)
            return {'success_message': _(u'Saved')}
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.groups.Group',
        request_method='GET',
        renderer='travelcrm:templates/groups#edit.pt',
        permission='edit'
    )
    def edit(self):
        resource = Resource.by_rid(self.request.params.get('rid'))
        group = resource.group
        return {'item': group}

    @view_config(
        name='edit',
        context='..resources.groups.Group',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        _ = self.request.translate
        schema = EditForm().bind(request=self.request)
        resource = Resource.by_rid(self.request.params.get('rid'))
        group = resource.group
        try:
            controls = schema.deserialize(self.request.params)
            group.name = controls.get('name')
            group.resource.status = controls.get('status')
            DBSession.add(group)
            return {'success_message': _(u'Saved')}
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='delete',
        context='..resources.groups.Groups',
        request_method='GET',
        renderer='travelcrm:templates/components/dialogs#delete.pt',
        permission='delete'
    )
    def delete(self):
        return {
            'rid': self.request.params.get('rid')
        }

    @view_config(
        name='delete',
        context='..resources.groups.Groups',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        _ = self.request.translate
        for rid in self.request.params.getall('rid'):
            resource = Resource.by_rid(rid)
            if resource:
                DBSession.delete(resource)
        return {'success_message': _(u'Deleted')}

    @view_config(
        name='permissions',
        context='..resources.groups.Group',
        request_method='GET',
        renderer='travelcrm:templates/groups#permissions.pt',
        permission='permissions'
    )
    def permissions(self):
        resource = Resource.by_rid(self.request.params.get('rid'))
        return {'item': resource.group}

    @view_config(
        name='permissions',
        context='..resources.groups.Group',
        request_method='POST',
        renderer='json',
        permission='permissions'
    )
    def _permissions(self):
        schema = PermissionsForm().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params)
            permissions = (
                DBSession.query(GroupPermision)
                .filter(
                    GroupPermision._groups_rid == controls.get('rid'),
                    GroupPermision._resources_types_rid == \
                        controls.get('_resources_types_rid')
                )
                .first()
            )
            if not permissions:
                resource = Resource.by_rid(controls.get('rid'))
                permissions = GroupPermision(
                    group=resource.group,
                    _resources_types_rid=(
                        controls.get('_resources_types_rid')
                    )
                )
            permissions.permissions = controls.get('permissions')
            DBSession.add(permissions)
            return {
                'success_message': self.request.translate(
                    u'Saved'
                ),
                'close': False
            }
        except colander.Invalid, e:
            return {
                'error_message': self.request.translate(
                    u'Please, check errors'
                ),
                'errors': e.asdict()
            }

    @view_config(
        name='resource_type_permissions',
        context='..resources.groups.Group',
        request_method='POST',
        renderer='json',
        permission='permissions'
    )
    def resource_type_permissions(self):
        _groups_rid = self.request.params.get('_groups_rid')
        _resources_types_rid = self.request.params.get('_resources_types_rid')
        permissions = (
            DBSession.query(GroupPermision.permissions)
            .filter(
                GroupPermision._groups_rid == _groups_rid,
                GroupPermision._resources_types_rid == _resources_types_rid
            )
            .scalar()
        )
        return permissions
