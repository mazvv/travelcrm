# -*-coding: utf-8 -*-

from pyramid.view import (
    view_config,
    forbidden_view_config
)


@view_config(
    name='system_need_select_row',
    request_method='GET',
    context='..resources.Root',
    renderer='travelcrm:templates/system#system_info_dialog.mak'
)
def system_need_select_row(context, request):
    _ = request.translate
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
    _ = request.translate
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
    _ = request.translate
    return {
        'title': _(u'Seccurity Info'),
        'message': _(u'You have no permissions to do this action')
    }
