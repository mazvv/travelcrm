import logging

from pyramid.security import forget
from pyramid.httpexceptions import HTTPNotFound, HTTPFound

from ...lib import helpers as h
from ...resources import Root
from ..utils.common_utils import translate as _
from ..utils.common_utils import get_multicompanies
from ..bl.employees import get_employee_structure
from ..scheduler import start_scheduler  
from ..utils.security_utils import get_auth_employee
from ..utils.companies_utils import (
    get_public_domain, 
    get_company
)
from ..utils.sql_utils import (
    get_default_schema,
    get_schemas,
    set_search_path
)


log = logging.getLogger(__name__)


def helpers(event):
    event.update({'h': h, '_': _})


def _company_settings(request, company):
    if company:
        settings = {
            'company.name': company.name,
            'company.base_currency': company.currency.iso_code,
            'company.locale_name': company.settings.get('locale'),
            'company.timezone': company.settings.get('timezone'),
        }
        request.registry.settings.update(settings)

    
def company_settings(event):
    request = event.request
    employee = get_auth_employee(request)
    if not employee:
        _company_settings(request, get_company())
        return
    structure = get_employee_structure(employee)
    if not structure:
        redirect_url = request.resource_url(Root(request))
        raise HTTPFound(location=redirect_url, headers=forget(request))
    _company_settings(request, structure.company)


def company_schema(event):
    request = event.request
    schema_name = get_default_schema()

    if not get_multicompanies() and get_public_domain() != request.domain:
        raise HTTPNotFound()
    elif get_public_domain() == request.domain:
        set_search_path(schema_name)
        return
    else:
        domain_parts = request.domain.split('.', 1)
        if len(domain_parts) > 1:
            schema_name = domain_parts[0]
            schemas = get_schemas()
            if schema_name in schemas:
                set_search_path(schema_name)
                return
    raise HTTPNotFound()


def scheduler(event):
    settings = event.app.registry.settings
    start_scheduler(settings)
