# -*-coding: utf-8-*-

import logging

from pyramid.view import view_config
from pyramid.renderers import render

from ..models.account import Account
from ..models.subaccount import Subaccount

from ..resources.subaccounts import Subaccounts
from ..resources.accounts import Accounts
from ..lib.qb.turnovers import (
    TurnoversAccountsQueryBuilder,
    TurnoversSubaccountsQueryBuilder,
)
from ..lib.qb.transfers import TransfersQueryBuilder
from ..lib.bl.transfers import (
    get_account_balance, 
    get_subaccount_balance,
)
from ..lib.utils.common_utils import translate as _
from ..lib.utils.common_utils import format_decimal
from ..forms.turnovers import TurnoverSearchSchema


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
        export = self.request.params.get('export')
        report_by = self.request.params.get('report_by')
        if report_by == 'account':
            qb = TurnoversAccountsQueryBuilder(Accounts(self.request))
        else:
            qb = TurnoversSubaccountsQueryBuilder(Subaccounts(self.request))
        schema = TurnoverSearchSchema().bind(request=self.request)
        controls = schema.deserialize(self.request.params.mixed())
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
        name='transfers',
        context='..resources.turnovers.Turnovers',
        request_method='GET',
        renderer='travelcrm:templates/turnovers/transfers.mak',
        permission='view'
    )
    def transfers(self):
        return {
            'title': _(u'Transfers'),
        }

    @view_config(
        name='transfers',
        context='..resources.turnovers.Turnovers',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def _transfers(self):
        schema = TurnoverSearchSchema().bind(request=self.request)
        controls = schema.deserialize(self.request.params.mixed())
        qb = TransfersQueryBuilder()
        qb.advanced_search(**controls)
        qb.sort_query(
            self.request.params.get('sort'),
            self.request.params.get('order', 'asc')
        )
        qb.page_query(
            int(self.request.params.get('rows')),
            int(self.request.params.get('page'))
        )
        if self.request.params.get('account_id'):
            account = Account.get(self.request.params.get('account_id'))
            currency = account.currency.iso_code
            balance = get_account_balance(
                account.id, 
                controls.get('date_from'), 
                controls.get('date_to')
            )
        elif self.request.params.get('subaccount_id'):
            subaccount = Subaccount.get(self.request.params.get('subaccount_id'))
            currency = subaccount.account.currency.iso_code
            balance = get_subaccount_balance(
                subaccount.id, 
                controls.get('date_from'), 
                controls.get('date_to')
            )
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized(),
            'footer': [{
                'date': _(u'balance'),
                'sum': format_decimal(balance),
                'currency': currency,
            }]
        }

    @view_config(
        name='export',
        context='..resources.turnovers.Turnovers',
        request_method='GET',
        renderer='pdf',
        permission='view'
    )
    def export(self):
        data = self.list()
        report_by = self.request.params.get('report_by')
        title_report_by = (
            _(u'Accounts') if report_by == 'account' else _(u'Subccounts')
        )
        data['title'] = _(u'Turnovers by ') + title_report_by
        body = render(
            'travelcrm:templates/turnovers/export.mak',
            data,
            self.request,
        )
        return {
            'body': body
        }
