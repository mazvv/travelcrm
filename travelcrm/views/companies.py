# -*-coding: utf-8-*-

import logging

from pyramid.view import view_config, view_defaults
from pyramid.response import Response
from pyramid.httpexceptions import HTTPFound

from . import BaseView
from ..models.company import Company
from ..models.resource import Resource
from ..lib.utils.security_utils import get_auth_employee
from ..lib.bl.employees import get_employee_structure
from ..lib.helpers.fields import companies_combogrid_field
from ..lib.utils.common_utils import translate as _
from ..forms.companies import (
    CompanyForm, 
    CompanySearchForm
)


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.companies.CompaniesResource',
)
class CompaniesView(BaseView):

    @view_config(
        name='list',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        form = CompanySearchForm(self.request, self.context)
        form.validate()
        qb = form.submit()
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized()
        }

    @view_config(
        name='view',
        request_method='GET',
        renderer='travelcrm:templates/companies/form.mako',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            company = Company.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': company.id}
                )
            )
        result = self.edit()
        result.update({
            'title': self._get_title(_(u'View')),
            'readonly': True,
        })
        return result


    @view_config(
        name='edit',
        request_method='GET',
        renderer='travelcrm:templates/companies/form.mako',
        permission='edit'
    )
    def edit(self):
        employee = get_auth_employee(self.request)
        structure = get_employee_structure(employee)
        return {
            'item': structure.company, 
            'title': self._get_title(_(u'Edit')),
        }

    @view_config(
        name='edit',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        employee = get_auth_employee(self.request)
        structure = get_employee_structure(employee)
        form = CompanyForm(self.request)
        if form.validate():
            form.submit(structure.company)
            return {
                'success_message': _(u'Saved'),
                'response': structure.company.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='combobox',
        request_method='POST',
        permission='view'
    )
    def _combobox(self):
        value = None
        resource = Resource.get(self.request.params.get('resource_id'))
        if resource:
            value = resource.company.id
        return Response(
            companies_combogrid_field(
                self.request, self.request.params.get('name'), value
            )
        )
