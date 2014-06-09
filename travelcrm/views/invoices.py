# -*-coding: utf-8-*-

import logging
from decimal import Decimal

import colander

from pyramid.view import view_config
from pyramid.httpexceptions import HTTPFound

from ..models import DBSession
from ..models.invoice import Invoice
from ..models.resource import Resource
from ..models.account import Account
from ..lib.qb.invoices import InvoicesQueryBuilder
from ..lib.utils.common_utils import translate as _

from ..forms.invoices import (
    InvoiceAddSchema,
    InvoiceEditSchema,
    InvoiceSumSchema,
)

from ..lib.utils.resources_utils import get_resource_class
from ..lib.bl.currencies_rates import query_convert_rates
from ..lib.bl.invoices import query_resource_data

log = logging.getLogger(__name__)


class Invoices(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.invoices.Invoices',
        request_method='GET',
        renderer='travelcrm:templates/invoices/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.invoices.Invoices',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        qb = InvoicesQueryBuilder(self.context)
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
        context='..resources.invoices.Invoices',
        request_method='GET',
        renderer='travelcrm:templates/invoices/form.mak',
        permission='add'
    )
    def add(self):
        resource_id = self.request.params.get('resource_id')
        resource = Resource.get(resource_id)
        source_cls = get_resource_class(resource.resource_type.name)
        factory = source_cls.get_invoice_factory()
        invoice = factory.get_invoice(resource_id)
        if invoice:
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'edit', query={'id': invoice.id}
                ),
            )

        structure_id = resource.owner_structure.id
        return {
            'title': _(u'Add Invoice'),
            'resource_id': resource_id,
            'structure_id': structure_id
        }

    @view_config(
        name='add',
        context='..resources.invoices.Invoices',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        schema = InvoiceAddSchema().bind(request=self.request)

        try:
            controls = schema.deserialize(self.request.params)
            resource_id = controls.get('resource_id')
            resource = Resource.get(resource_id)
            source_cls = get_resource_class(resource.resource_type.name)
            factory = source_cls.get_invoice_factory()
            invoice = Invoice(
                date=controls.get('date'),
                account_id=controls.get('account_id'),
                resource=self.context.create_resource()
            )
            source = factory.bind_invoice(resource_id, invoice)
            DBSession.add(source)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': invoice.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.invoices.Invoices',
        request_method='GET',
        renderer='travelcrm:templates/invoices/form.mak',
        permission='edit'
    )
    def edit(self):
        invoice = Invoice.get(self.request.params.get('id'))
        bound_resource = (
            query_resource_data()
            .filter(Invoice.id == invoice.id)
            .first()
        )
        structure_id = invoice.resource.owner_structure.id
        return {
            'item': invoice,
            'structure_id': structure_id,
            'resource_id': bound_resource.resource_id,
            'title': _(u'Edit Invoice')
        }

    @view_config(
        name='edit',
        context='..resources.invoices.Invoices',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        schema = InvoiceEditSchema().bind(request=self.request)
        invoice = Invoice.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params)
            invoice.date = controls.get('date')
            invoice.account_id = controls.get('account_id')
            return {
                'success_message': _(u'Saved'),
                'response': invoice.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='delete',
        context='..resources.invoices.Invoices',
        request_method='GET',
        renderer='travelcrm:templates/invoices/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'rid': self.request.params.get('rid')
        }

    @view_config(
        name='delete',
        context='..resources.invoices.Invoices',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        for id in self.request.params.getall('id'):
            invoice = Invoice.get(id)
            if invoice:
                DBSession.delete(invoice)
        return {'success_message': _(u'Deleted')}

    @view_config(
        name='sum',
        context='..resources.invoices.Invoices',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def sum(self):
        schema = InvoiceSumSchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params)
            resource_id = controls.get('resource_id')
            account_id = controls.get('account_id')
            date = controls.get('date')
            resource = Resource.get(resource_id)
            source_cls = get_resource_class(resource.resource_type.name)
            factory = source_cls.get_invoice_factory()
            sum, in_currency_id = factory.get_sum(resource_id)
            account = Account.get(account_id)

            query_rate_converter = query_convert_rates(
                in_currency_id, account.currency_id, date
            )
            rate = query_rate_converter.scalar() or 1
            sum = sum * rate
            return {
                'sum': str(Decimal(sum).quantize(Decimal('.01'))),
                'currency': account.currency.iso_code
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }
