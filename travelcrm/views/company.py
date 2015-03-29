# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound

from ..models.company import Company
from ..lib.utils.security_utils import get_auth_employee
from ..lib.bl.employees import get_employee_structure
from ..lib.utils.common_utils import translate as _
from ..forms.company import CompanyForm


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.company.CompanyResource',
)
class CompanyView(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        name='view',
        request_method='GET',
        renderer='travelcrm:templates/company/form.mak',
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
            'title': _(u"View Company"),
            'readonly': True,
        })
        return result


    @view_config(
        name='edit',
        request_method='GET',
        renderer='travelcrm:templates/company/form.mak',
        permission='edit'
    )
    def edit(self):
        employee = get_auth_employee(self.request)
        structure = get_employee_structure(employee)
        return {'item': structure.company, 'title': _(u'Edit Company')}

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
