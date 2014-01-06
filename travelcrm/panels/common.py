# -*-coding: utf-8 -*-

from pyramid.security import authenticated_userid

from pyramid_layout.panel import panel_config

from ..models.user import User
from ..models.resource import Resource
from ..models.group_navigation import GroupNavigation


@panel_config(
    'header_panel',
    renderer='travelcrm:templates/panels/common#header.pt'
)
def header(context, request):
    return {}


@panel_config(
    'footer_panel',
    renderer='travelcrm:templates/panels/common#footer.pt'
)
def footer(context, request):
    return {}


@panel_config(
    'navigation_panel',
    renderer='travelcrm:templates/panels/common#navigation.pt'
)
def navigation(context, request):
    users_rid = authenticated_userid(request)
    user = User.by_rid(users_rid)

    # TODO: make it for multigroup users
    group = user.groups[0]
    _navigation = (
        group
        .group_navigations
        .join(Resource)
        .filter(
            Resource.condition_active(),
        )
    )
    navigation = {}
    for item in _navigation:
        item_children = navigation.setdefault(item._groups_navigations_rid, [])
        item_children.append(item)
        navigation[item._groups_navigations_rid] = item_children
    return {'navigation': navigation}
