# -*-coding: utf-8-*-

import logging

from pyramid.view import view_config, view_defaults
from pyramid.renderers import render

from ..models.account import Account
from ..models.subaccount import Subaccount

from ..resources.subaccount import SubaccountResource
from ..resources.account import AccountResource
from ..lib.qb.turnover import (
    TurnoverAccountQueryBuilder,
    TurnoverSubaccountQueryBuilder,
)
from ..lib.qb.cashflow import CashflowQueryBuilder
from ..lib.bl.cashflows import (
    get_account_balance, 
    get_subaccount_balance,
)
from ..lib.utils.common_utils import translate as _
from ..lib.utils.common_utils import format_decimal
from ..forms.turnover import TurnoverSearchSchema


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.turnover.TurnoverResource',
)
class TurnoverView(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/turnovers/index.mak',
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
        export = self.request.params.get('export')
        report_by = self.request.params.get('report_by')
        if report_by == 'account':
            qb = TurnoverAccountQueryBuilder(AccountResource(self.request))
        else:
            qb = TurnoverSubaccountQueryBuilder(
                SubaccountResource(self.request)
            )
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
        name='cashflows',
        request_method='GET',
        renderer='travelcrm:templates/turnovers/cashflows.mak',
        permission='view'
    )
    def cashflows(self):
        return {
            'title': _(u'Cashflows'),
        }

    @view_config(
        name='cashflows',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def _cashflows(self):
        schema = TurnoverSearchSchema().bind(request=self.request)
        controls = schema.deserialize(self.request.params.mixed())
        qb = CashflowQueryBuilder()
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
