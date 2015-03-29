# -*-coding: utf-8-*-

import logging

from pyramid.view import view_config, view_defaults
from pyramid.renderers import render

from ..lib.qb.debt import DebtQueryBuilder
from ..forms.debt import DebtSearchSchema


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.debt.DebtResource',
)
class DebtView(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/debts/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        schema = DebtSearchSchema().bind(request=self.request)
        controls = schema.deserialize(self.request.params.mixed())
        export = self.request.params.get('export')
        qb = DebtQueryBuilder(self.context)
        qb.search_simple(controls.get('q'))
        qb.advanced_search(**controls)
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
