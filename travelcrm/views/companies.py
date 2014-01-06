# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.company import Company
from ..models.resource import Resource

from ..forms.companies import (
    AddForm,
    EditForm,
)


log = logging.getLogger(__name__)


class Groups(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.companies.Companies',
        request_method='GET',
        renderer='travelcrm:templates/companies#index.pt',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.companies.Companies',
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
        context='..resources.companies.Company',
        request_method='GET',
        renderer='travelcrm:templates/companies#form.pt',
        permission='add'
    )
    def add(self):
        return {}

    @view_config(
        name='add',
        context='..resources.companies.Company',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        _ = self.request.translate
        schema = AddForm().bind(request=self.request)

        try:
            controls = schema.deserialize(self.request.params)
            company = Company(
                name=controls.get('name'),
                resource=self.context.create_resource(controls.get('status'))
            )
            DBSession.add(company)
            return {'success_message': _(u'Saved')}
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.companies.Company',
        request_method='GET',
        renderer='travelcrm:templates/companies#form.pt',
        permission='edit'
    )
    def edit(self):
        _ = self.request.translate
        resource = Resource.by_rid(self.request.params.get('rid'))
        company = resource.company
        return {'item': company, 'title': _(u'Edit Company')}

    @view_config(
        name='edit',
        context='..resources.companies.Company',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        _ = self.request.translate
        schema = EditForm().bind(request=self.request)
        resource = Resource.by_rid(self.request.params.get('rid'))
        company = resource.company
        try:
            controls = schema.deserialize(self.request.params)
            company.name = controls.get('name')
            company.resource.status = controls.get('status')
            return {'success_message': _(u'Saved')}
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='delete',
        context='..resources.companies.Companies',
        request_method='GET',
        renderer='travelcrm:templates/companies#delete.pt',
        permission='delete'
    )
    def delete(self):
        return {
            'rid': self.request.params.get('rid')
        }

    @view_config(
        name='delete',
        context='..resources.companies.Companies',
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
        name='combobox',
        context='..resources.companies.Companies',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def _combobox(self):
        q = self.request.params.get('q')
        items = (
            DBSession.query(
                Company.rid,
                Company.name
            )
            .filter(Company.name.like("{0}%".format(q)))
            .order_by(Company.name)
        )
        return [
            {'rid': item.rid, 'name': item.name}
            for item in items
        ]
