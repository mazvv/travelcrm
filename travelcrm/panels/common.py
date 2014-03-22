# -*-coding: utf-8 -*-

from pyramid_layout.panel import panel_config


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
