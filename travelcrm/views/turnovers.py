# -*-coding: utf-8-*-

import logging

from pyramid.view import view_config

from ..lib.qb.turnovers import TurnoversQueryBuilder


log = logging.getLogger(__name__)


class Turnovers(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.turnovers.Turnovers',
        request_method='GET',
        renderer='travelcrm:templates/turnovers/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.turnovers.Turnovers',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        qb = TurnoversQueryBuilder()
        qb.sort_query(
            self.request.params.get('sort'),
            self.request.params.get('order', 'asc')
        )
        qb.page_query(
            int(self.request.params.get('rows')),
            int(self.request.params.get('page'))
        )
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized()
        }
