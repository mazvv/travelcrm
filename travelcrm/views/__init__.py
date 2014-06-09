# -*-coding: utf-8 -*-

from pyramid.view import (
    view_config,
    forbidden_view_config
)
from pyramid.security import authenticated_userid

from ..models.user import User
from ..lib.bl.employees import get_employee_position
from ..lib.utils.common_utils import translate as _


@view_config(
    name='system_need_select_row',
    request_method='GET',
    context='..resources.Root',
    renderer='travelcrm:templates/system#system_info_dialog.mak'
)
def system_need_select_row(context, request):
    return {
        'title': _(u'System Info'),
        'message': _(u'Need to select row')
    }


@view_config(
    name='system_need_select_rows',
    request_method='GET',
    context='..resources.Root',
    renderer='travelcrm:templates/system#system_info_dialog.mak'
)
def system_need_select_rows(context, request):
    return {
        'title': _(u'System Info'),
        'message': _(u'Need to check rows')
    }


@view_config(
    name='system_not_configurable',
    request_method='GET',
    context='..resources.Root',
    renderer='travelcrm:templates/system#system_info_dialog.mak'
)
def system_need_select_rows(context, request):
    return {
        'title': _(u'System Info'),
        'message': _(u'Selected Resource Type is not configurable')
    }


@forbidden_view_config(
    request_method="GET",
    xhr=True,
    renderer="travelcrm:templates/system#system_info_dialog.mak",
)
def system_resource_forbidden(context, request):
    return {
        'title': _(u'Seccurity Info'),
        'message': _(u'You have no permissions to do this action')
    }


@view_config(
    name='system_navigation',
    request_method='GET',
    context='..resources.Root',
    renderer='travelcrm:templates/system#system_navigation.mak'
)
def system_navigation(context, request):
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
