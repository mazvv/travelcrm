# -*-coding: utf-8 -*-

from pyramid.security import authenticated_userid

from pyramid_layout.panel import panel_config

from ..models.user import User
from ..lib.bl.employees import get_employee_position


@panel_config(
    'header_panel',
    renderer='travelcrm:templates/panels/common#header.mak'
)
def header(context, request):
    return {}


@panel_config(
    'footer_panel',
    renderer='travelcrm:templates/panels/common#footer.mak'
)
def footer(context, request):
    return {}


@panel_config(
    'navigation_panel',
    renderer='travelcrm:templates/panels/common#navigation.mak'
)
def navigation(context, request):
    user_id = authenticated_userid(request)
    user = User.get(user_id)
    employee = user.employee
    employee_position = get_employee_position(employee)

    _navigations = employee_position.navigations
    navigation = {}
    for item in _navigations:
        item_children = navigation.setdefault(item.parent_id, [])
        item_children.append(item)
        navigation[item.parent_id] = item_children
    return {'navigation': navigation}
