#-*-coding: utf-8

import logging
import copy
from datetime import datetime, timedelta

from pyramid.security import forget
from pyramid.httpexceptions import HTTPNotFound, HTTPFound

from ...lib import helpers as h
from ...resources import Root
from ..utils.common_utils import translate as _
from ..utils.common_utils import (
    get_multicompanies,
    cast_int,
    get_tarifs,
    get_tarifs_timeout
)
from ..bl.employees import get_employee_structure
from ..scheduler import start_scheduler
from ..utils.security_utils import get_auth_employee
from ..utils.companies_utils import (
    get_public_domain,
    get_company,
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
            'company.tarif_code': company.settings.get('tarif_code'),
            'company.tarif_limit': company.settings.get('tarif_limit'),
            'company.tarif_expired': company.settings.get('tarif_expired'),
        }
        request.registry.settings.update(settings)


def _check_tarif_control(request, company):
    """check the possibility to make request from current IP
    """
    if not get_tarifs():
        return

    ip_limit = cast_int(company.settings.get('tarif_limit'))
    if not ip_limit:
        return

    ips = company.settings.get('tarif_ips', [])
    new_ips = []
    timeout = get_tarifs_timeout()
    ip_already_in = False
    dt_format = '%Y-%m-%dT%H:%M:%S'
    for ip, last_activity in ips:
        last_activity = datetime.strptime(last_activity, dt_format)
        if (
            (last_activity + timedelta(seconds=timeout)) <= datetime.now()
            and ip != request.client_addr
        ):
            continue
        elif ip == request.client_addr:
            new_ips.append((ip, datetime.now().strftime(dt_format)))
            ip_already_in = True
        else:
            new_ips.append((ip, last_activity.strftime(dt_format)))

    if len(new_ips) >= ip_limit and not ip_already_in:
        log.error(_(u'IP limit exceeded'))
        redirect_url = request.resource_url(Root(request))
        raise HTTPFound(location=redirect_url, headers=forget(request))
    if not ip_already_in:
        new_ips.append(
            (request.client_addr, datetime.now().strftime(dt_format))
        )
    settings = copy.copy(company.settings)
    settings['tarif_ips'] = new_ips
    company.settings = settings


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
    _check_tarif_control(request, structure.company)
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
