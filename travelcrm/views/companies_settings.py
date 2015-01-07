# -*-coding: utf-8-*-

import logging

from pyramid.view import view_config
from pyramid.httpexceptions import HTTPFound

from ..resources.companies import Companies
from ..lib.utils.security_utils import get_auth_employee
from ..lib.bl.employees import get_employee_structure


log = logging.getLogger(__name__)


class CompaniesSettings(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.companies_settings.CompaniesSettings',
        request_method='GET',
        renderer='json',
        permission='view'
    )
    def index(self):
        context = Companies(self.request)
        employee = get_auth_employee(self.request)
        structure = get_employee_structure(employee)
        return HTTPFound(
            location=self.request.resource_url(
                context, 'edit', query={'id': structure.company.id}
            )
        )
