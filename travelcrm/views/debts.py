# -*-coding: utf-8-*-

import logging

from pyramid.view import view_config
from pyramid.renderers import render

from ..lib.qb.debts import DebtsQueryBuilder


log = logging.getLogger(__name__)


class Debts(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.debts.Debts',
        request_method='GET',
        renderer='travelcrm:templates/debts/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.debts.Debts',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        export = self.request.params.get('export')
        qb = DebtsQueryBuilder(self.context)
        qb.search_simple(
            self.request.params.get('q'),
        )
        qb.advanced_search(
            **self.request.params.mixed()
        )
        qb.sort_query(
            self.request.params.get('sort'),
            self.request.params.get('order', 'asc')
        )
        if export:
            return {
                'total': qb.get_count(),
                'rows': qb.get_serialized()
            }
        qb.page_query(
            int(self.request.params.get('rows')),
            int(self.request.params.get('page'))
        )
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized()
        }

    @view_config(
        name='export',
        context='..resources.debts.Debts',
        request_method='GET',
        renderer='pdf',
        permission='view'
    )
    def export(self):
        data = self.list()
        body = render(
            'travelcrm:templates/debts/export.mak',
            data,
            self.request,
        )
        return {
            'body': body
        }
