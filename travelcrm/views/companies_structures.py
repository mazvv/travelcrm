# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.company import Company
from ..models.company_struct import CompanyStruct
from ..models.resource import Resource

from ..forms.companies_structures import (
    AddForm,
    EditForm,
)


log = logging.getLogger(__name__)


class CompaniesStructures(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.companies_structures.CompaniesStructures',
        request_method='GET',
        renderer='travelcrm:templates/companies_structures#index.pt',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.companies_structures.CompaniesStructures',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        struct_resource_rid = self.request.params.get('id')
        sort = self.request.params.get('sort')
        order = self.request.params.get('order', 'asc')
        page = self.request.params.get('page')
        rows = self.request.params.get('rows')
        if struct_resource_rid:
            resource = Resource.by_rid(struct_resource_rid)
            self.context.set_struct_rid(resource.company_struct.rid)
        json_data = self.context.get_json_page(sort, order, page, rows)
        if struct_resource_rid:
            return json_data.get('rows')
        return json_data

    @view_config(
        name='add',
        context='..resources.companies_structures.CompanyStructure',
        request_method='GET',
        renderer='travelcrm:templates/companies_structures#form.pt',
        permission='add'
    )
    def add(self):
        company = Company.by_rid(self.request.params.get('rid'))
        return {'company': company}

    @view_config(
        name='add',
        context='..resources.companies_structures.CompanyStructure',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        _ = self.request.translate
        schema = AddForm().bind(request=self.request)

        try:
            controls = schema.deserialize(self.request.params)
            company_struct = CompanyStruct(
                name=controls.get('name'),
                _companies_rid=controls.get('_companies_rid'),
                _companies_structures_rid=controls.get(
                    '_companies_structures_rid'
                ),
                resource=self.context.create_resource(controls.get('status'))
            )
            DBSession.add(company_struct)
            return {'success_message': _(u'Saved')}
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.companies_structures.CompanyStructure',
        request_method='GET',
        renderer='travelcrm:templates/companies_structures#form.pt',
        permission='edit'
    )
    def edit(self):
        resource = Resource.by_rid(self.request.params.get('rid'))
        item = resource.company_struct
        company = item.company
        return {'item': item, 'company': company}

    @view_config(
        name='edit',
        context='..resources.companies_structures.CompanyStructure',
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
        context='..resources.companies_structures.CompaniesStructures',
        request_method='GET',
        renderer='travelcrm:templates/companies_structures#delete.pt',
        permission='delete'
    )
    def delete(self):
        return {
            'rid': self.request.params.get('rid')
        }

    @view_config(
        name='delete',
        context='..resources.companies_structures.CompaniesStructures',
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
        name='combotree',
        context='..resources.companies_structures.CompaniesStructures',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def _combotree(self):
        _companies_rid = self.request.params.get('rid')
        _structures = (
            DBSession.query(CompanyStruct)
            .filter(CompanyStruct._companies_rid == _companies_rid)
            .order_by(CompanyStruct.name)
        )
        structures = {}
        roots = []

        for item in _structures:
            item_children = structures.setdefault(
                item._companies_structures_rid, []
            )
            item_children.append(item)
            structures[item._companies_structures_rid] = item_children
            if not item._companies_structures_rid:
                roots.append(item)

        def tree(node):
            result = {
                'id': node.rid,
                'text': node.name,
            }
            if structures.get(node.rid):
                result['state'] = 'closed'
                result['children'] = [
                    tree(item)
                    for item
                    in structures.get(node.rid)
                ]
            return result

        result = [tree(item) for item in roots]
        return result
