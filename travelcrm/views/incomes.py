# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.income import Income
from ..models.address import Address
from ..models.invoice import Invoice
from ..lib.qb.incomes import IncomesQueryBuilder
from ..lib.bl.invoices import get_factory_by_invoice_id
from ..lib.utils.common_utils import translate as _

from ..forms.incomes import IncomeSchema, IncomeCurrencySchema


log = logging.getLogger(__name__)


class Incomes(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.incomes.Incomes',
        request_method='GET',
        renderer='travelcrm:templates/incomes/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.incomes.Incomes',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        qb = IncomesQueryBuilder(self.context)
        qb.search_simple(
            self.request.params.get('q'),
        )
        qb.advanced_search(
            updated_from=self.request.params.get('updated_from'),
            updated_to=self.request.params.get('updated_to'),
            modifier_id=self.request.params.get('modifier_id'),
        )
        id = self.request.params.get('id')
        if id:
            qb.filter_id(id.split(','))
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

    @view_config(
        name='add',
        context='..resources.incomes.Incomes',
        request_method='GET',
        renderer='travelcrm:templates/incomes/form.mak',
        permission='add'
    )
    def add(self):
        return {'title': _(u'Add Income')}

    @view_config(
        name='add',
        context='..resources.incomes.Incomes',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        schema = IncomeSchema().bind(request=self.request)

        try:
            controls = schema.deserialize(self.request.params)
            income = Income(
                invoice_id=controls.get('invoice_id'),
                resource=self.context.create_resource()
            )
            factory = get_factory_by_invoice_id(controls.get('invoice_id'))
            income.transactions = factory.make_payment(
                controls.get('invoice_id'),
                controls.get('date'),
                controls.get('sum')
            )
            DBSession.add(income)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': income.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.incomes.Incomes',
        request_method='GET',
        renderer='travelcrm:templates/incomes/form.mak',
        permission='edit'
    )
    def edit(self):
        income = Income.get(self.request.params.get('id'))
        return {'item': income, 'title': _(u'Edit Income')}

    @view_config(
        name='edit',
        context='..resources.incomes.Incomes',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        schema = IncomeSchema().bind(request=self.request)
        income = Income.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params)
            income.invoice_id = controls.get('invoice_id')
            factory = get_factory_by_invoice_id(controls.get('invoice_id'))
            income.transactions = factory.make_payment(
                controls.get('invoice_id'),
                controls.get('date'),
                controls.get('sum')
            )
            return {
                'success_message': _(u'Saved'),
                'response': income.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='delete',
        context='..resources.incomes.Incomes',
        request_method='GET',
        renderer='travelcrm:templates/incomes/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'rid': self.request.params.get('rid')
        }

    @view_config(
        name='delete',
        context='..resources.incomes.Incomes',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        for id in self.request.params.getall('id'):
            income = Income.get(id)
            if income:
                DBSession.delete(income)
        return {'success_message': _(u'Deleted')}

    @view_config(
        name='currency',
        context='..resources.incomes.Incomes',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def currency(self):
        schema = IncomeCurrencySchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params)
            invoice_id = controls.get('invoice_id')
            invoice = Invoice.get(invoice_id)
            return {
                'currency': invoice.account.currency.iso_code
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }
