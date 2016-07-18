# -*-coding: utf-8-*-

import logging

from pyramid.view import view_config, view_defaults

from . import BaseView
from ..lib.utils.common_utils import serialize
from ..lib.utils.common_utils import translate as _
from ..forms.turnovers import TurnoverSearchForm


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.turnovers.TurnoversResource',
)
class TurnoversView(BaseView):

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/turnovers/index.mako',
        permission='view'
    )
    def index(self):
        return {
            'title': self._get_title(),
        }

    @view_config(
        name='list',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        form = TurnoverSearchForm(self.request, self.context)
        form.validate()
        qb = form.submit()
        revenue = 0
        expenses = 0
        balance = 0
        for row in qb.query:
            if row.revenue:
                revenue += row.revenue
            if row.expenses:
                expenses += row.expenses
            if row.balance:
                balance += row.balance
        footer = [{
            'name': _(u'total'),
            'iconCls': 'fa fa-square',
            'revenue': serialize(revenue),
            'expenses': serialize(expenses),
            'balance': serialize(balance),
        }]
        return {
            'footer': footer,
            'rows': qb.get_serialized(),
        }

    @view_config(
        name='export',
        request_method='GET',
        permission='view',
        renderer='travelcrm:templates/turnovers/export.mako'
    )
    def export(self):
        return self.list()
