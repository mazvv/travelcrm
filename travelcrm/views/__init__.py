# -*-coding: utf-8 -*-

from pyramid.view import (
    view_config,
    forbidden_view_config
)
from pyramid.security import authenticated_userid

from ..models.user import User
from ..models.resource_type import ResourceType
from ..lib.bl.employees import get_employee_position, get_employee_permisions
from ..lib.bl.structures import get_structure_name_path 
from ..lib.utils.resources_utils import get_resource_class
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


@view_config(
    name='system_context_info',
    request_method='GET',
    context='..resources.Root',
    xhr='True',
    renderer='travelcrm:templates/system#system_context_info_dialog.mak'
)
def system_context_info(context, request):
    return {
        'title': _(u'Context Info'),
    }


@view_config(
    name='system_context_info',
    request_method='POST',
    context='..resources.Root',
    xhr='True',
    renderer='json'
)
def _system_context_info(context, request):
    user_id = authenticated_userid(request)
    user = User.get(user_id)
    employee = user.employee
    rt = ResourceType.by_name(request.params.get('rt'))
    rt_cls = get_resource_class(request.params.get('rt'))
    permisions = get_employee_permisions(employee, rt_cls)
    common_group_title = _(u'Common')
    permisions_group_title = _(u'Permissions')
    rows = []
    rows.append({
        'name': _(u'Resource Name'),
        'value': rt.humanize,
        'group': common_group_title
    })    
    rows.append({
        'name': _(u'Resource System Name'),
        'value': rt.name,
        'group': common_group_title
    })
    rows.append({
        'name': _(u'Rights'),
        'value': ', '.join(permisions.permisions),
        'group': permisions_group_title
    })    
    rows.append({
        'name': _(u'Scope'),
        'value': (
            '&rarr;'.join(get_structure_name_path(permisions.structure)) 
            if permisions.structure else _(u'All')
        ),
        'group': permisions_group_title
    })    
    return {
        'total': len(rows),
        'rows': rows,
    }


@view_config(
    name='system_portal',
    request_method='GET',
    context='..resources.Root',
    xhr='True',
    renderer='travelcrm:templates/system#system_portal.mak'
)
def system_portal(context, request):
    return {}
