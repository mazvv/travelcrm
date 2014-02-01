# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.company import Company
from ..models.company_struct import CompanyStruct
from ..models.resource import Resource
from ..lib.bl.companies_structures import CompaniesStructuresQueryBuilder
from ..forms.companies_structures import CompanyStructureSchema


log = logging.getLogger(__name__)


class CompaniesStructures(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.companies_structures.CompaniesStructures',
        request_method='GET',
        renderer='travelcrm:templates/companies_structures/index.mak',
        permission='view'
    )
    def index(self):
        company = Company.get(self.request.params.get('id'))
        return {'company': company}

    @view_config(
        name='list',
        context='..resources.companies_structures.CompaniesStructures',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        parent_id = self.request.params.get('id')
        companies_id = self.request.params.get('companies_id')

        qb = CompaniesStructuresQueryBuilder()
        qb.filter_company_id(companies_id)
        qb.filter_parent_id(
            parent_id,
            with_chain=self.request.params.get('with_chain')
        )
        qb.sort_query(
            self.request.params.get('sort'),
            self.request.params.get('order', 'asc')
        )
        if self.request.params.get('rows'):
            qb.page_query(
                int(self.request.params.get('rows')),
                int(self.request.params.get('page', 1))
            )
        return qb.get_serialized()

    @view_config(
        name='add',
        context='..resources.companies_structures.CompanyStructure',
        request_method='GET',
        renderer='travelcrm:templates/companies_structures/form.mak',
        permission='add'
    )
    def add(self):
        _ = self.request.translate
        company = Company.get(self.request.params.get('companies_id'))
        return {
            'company': company,
            'title': _(u"Add Company Structure")
        }

    @view_config(
        name='add',
        context='..resources.companies_structures.CompanyStructure',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        _ = self.request.translate
        schema = CompanyStructureSchema().bind(request=self.request)

        try:
            controls = schema.deserialize(self.request.params)
            company_struct = CompanyStruct(
                name=controls.get('name'),
                companies_id=controls.get('companies_id'),
                parent_id=controls.get('parent_id'),
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
        renderer='travelcrm:templates/companies_structures/form.mak',
        permission='edit'
    )
    def edit(self):
        _ = self.request.translate
        struct = CompanyStruct.get(self.request.params.get('id'))
        company = struct.company
        return {
            'title': _(u"Edit Company Structure"),
            'item': struct,
            'company': company
        }

    @view_config(
        name='edit',
        context='..resources.companies_structures.CompanyStructure',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        _ = self.request.translate
        schema = CompanyStructureSchema().bind(request=self.request)
        company_struct = CompanyStruct.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params)
            company_struct.name = controls.get('name')
            company_struct.companies_id = controls.get('companies_id')
            company_struct.parent_id = controls.get('parent_id')
            company_struct.resource.status = controls.get('status')
            return {'success_message': _(u'Saved')}
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='copy',
        context='..resources.companies_structures.CompanyStructure',
        request_method='GET',
        renderer='travelcrm:templates/companies_structures/form.mak',
        permission='add'
    )
    def copy(self):
        _ = self.request.translate
        struct = CompanyStruct.get(self.request.params.get('id'))
        company = struct.company
        return {
            'title': _(u"Copy Company Structure"),
            'item': struct,
            'company': company
        }

    @view_config(
        name='delete',
        context='..resources.companies_structures.CompaniesStructures',
        request_method='GET',
        renderer='travelcrm:templates/companies_structures/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'id': self.request.params.get('id')
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
        for id in self.request.params.getall('id'):
            company_struct = CompanyStruct.get(id)
            if company_struct:
                DBSession.delete(company_struct)
        return {'success_message': _(u'Deleted')}
