# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.employee import Employee
from ..models.resource import Resource

from ..forms.groups import (
    AddForm,
    EditForm,
)


log = logging.getLogger(__name__)


class Employees(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.employees.Employees',
        request_method='GET',
        renderer='travelcrm:templates/employees#index.pt',
        layout='main_layout',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.employees.Employees',
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
        context='..resources.employees.Employee',
        request_method='GET',
        renderer='travelcrm:templates/employees#add.pt',
        permission='add'
    )
    def add(self):
        return {}

    @view_config(
        name='add',
        context='..resources.employees.Employee',
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
        context='..resources.employees.Employee',
        request_method='GET',
        renderer='travelcrm:templates/employees#edit.pt',
        permission='edit'
    )
    def edit(self):
        resource = Resource.by_id(self.request.params.get('rid'))
        group = resource.group
        return {'item': group}

    @view_config(
        name='edit',
        context='..resources.employees.Employee',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        _ = self.request.translate
        schema = EditForm().bind(request=self.request)
        resource = Resource.by_id(self.request.params.get('rid'))
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
        context='..resources.employees.Employees',
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
        context='..resources.employees.Employees',
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
