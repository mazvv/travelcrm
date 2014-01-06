# -*-coding: utf-8 -*-

from pyramid_layout.layout import layout_config


@layout_config(
    name='auth_layout',
    template='travelcrm:templates/layouts/auth.mak'
)
class AdminAuthLayout(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request


@layout_config(
    name='main_layout',
    template='travelcrm:templates/layouts/main.mak'
)
class AdminMainLayout(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request
