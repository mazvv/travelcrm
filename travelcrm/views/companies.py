# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.company import Company
from ..lib.qb.companies import CompaniesQueryBuilder

from ..forms.companies import CompanySchema


log = logging.getLogger(__name__)


class Companies(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.companies.Companies',
        request_method='GET',
        renderer='travelcrm:templates/companies/index.mak',
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
        qb = CompaniesQueryBuilder(self.context)
        qb.sort_query(
            self.request.params.get('sort'),
            self.request.params.get('order', 'asc')
        )
        qb.structs_quan_query()
        qb.page_query(
            int(self.request.params.get('rows')),
            int(self.request.params.get('page'))
        )
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized()
        }

    @view_config(
        name='add',
        context='..resources.companies.Companies',
        request_method='GET',
        renderer='travelcrm:templates/companies/form.mak',
        permission='add'
    )
    def add(self):
        return {}

    @view_config(
        name='add',
        context='..resources.companies.Companies',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        _ = self.request.translate
        schema = CompanySchema().bind(request=self.request)

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
        context='..resources.companies.Companies',
        request_method='GET',
        renderer='travelcrm:templates/companies/form.mak',
        permission='edit'
    )
    def edit(self):
        _ = self.request.translate
        company = Company.get(self.request.params.get('id'))
        return {'item': company, 'title': _(u'Edit Company')}

    @view_config(
        name='edit',
        context='..resources.companies.Companies',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        _ = self.request.translate
        schema = CompanySchema().bind(request=self.request)
        company = Company.get(self.request.params.get('id'))
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
        renderer='travelcrm:templates/companies/delete.mak',
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
        for id in self.request.params.getall('id'):
            company = Company.get(id)
            if company:
                DBSession.delete(company)
        return {'success_message': _(u'Deleted')}
