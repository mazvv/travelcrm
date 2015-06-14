# -*-coding: utf-8 -*-

from pyramid_layout.panel import panel_config

from ..lib.utils.security_utils import get_auth_employee
from ..lib.utils.common_utils import get_company_name
from ..lib.bl.employees import get_employee_position, get_employee_structure
from ..lib.bl.structures import get_structure_name_path


@panel_config(
    'header_panel',
    renderer='travelcrm:templates/panels/common#header.mako'
)
def header(context, request):
    company_name = get_company_name()
    return {'company_name': company_name}


@panel_config(
    'footer_panel',
    renderer='travelcrm:templates/panels/common#footer.mako'
)
def footer(context, request):
    return {}


@panel_config(
    'employee_info_panel',
    renderer='travelcrm:templates/panels/common#employee_info.mako'
)
def employee_info(context, request):
    employee = get_auth_employee(request)
    position = get_employee_position(employee)
    structure = get_employee_structure(employee)
    path = get_structure_name_path(structure)
    return {
        'employee': employee,
        'position': position,
        'structure_path': path
    }
