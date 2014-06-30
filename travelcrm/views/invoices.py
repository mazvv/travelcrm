# -*-coding: utf-8-*-

import logging
from decimal import Decimal

import colander
import pdfkit
from babel.numbers import format_decimal

from pyramid.view import view_config
from pyramid.httpexceptions import HTTPFound
from pyramid.response import Response

from ..models import DBSession
from ..models.invoice import Invoice
from ..models.resource import Resource
from ..models.account import Account
from ..lib.qb import query_serialize
from ..lib.qb.invoices import InvoicesQueryBuilder
from ..lib.utils.common_utils import translate as _

from ..forms.invoices import (
    InvoiceAddSchema,
    InvoiceEditSchema,
    InvoiceSumSchema,
)

from ..lib.utils.resources_utils import get_resource_class
from ..lib.utils.common_utils import get_locale_name
from ..lib.bl.currencies_rates import query_convert_rates
from ..lib.bl.invoices import query_resource_data, query_invoice_payments

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
            **self.request.params.mixed()
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
            'title': _(u'Delete Invoices'),
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
        errors = 0
        for id in self.request.params.getall('id'):
            item = Invoice.get(id)
            if item:
                DBSession.begin_nested()
                try:
                    DBSession.delete(item)
                    DBSession.commit()
                except:
                    errors += 1
                    DBSession.rollback()
        if errors > 0:
            return {
                'error_message': _(
                    u'Some objects could not be delete'
                ),
            }
        return {'success_message': _(u'Deleted')}

    @view_config(
        name='pdf',
        context='..resources.invoices.Invoices',
        request_method='GET',
        permission='view'
    )
    def pdf(self):
        invoice = Invoice.get(self.request.params.get('id'))
        structure = invoice.resource.owner_structure
        output = pdfkit.from_string(structure.invoice_template, False)
        return Response(
            output, headerlist=[('Content-Type', 'application/pdf')]
        )

    @view_config(
        name='invoice_sum',
        context='..resources.invoices.Invoices',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def invoice_sum(self):
        schema = InvoiceSumSchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params)
            resource_id = controls.get('resource_id')
            account_id = controls.get('account_id')
            date = controls.get('date')
            resource = Resource.get(resource_id)
            source_cls = get_resource_class(resource.resource_type.name)
            factory = source_cls.get_invoice_factory()
            invoice_sum = factory.get_base_sum(resource_id)
            account = Account.get(account_id)
            query_rate_converter = query_convert_rates(
                account.currency_id, date
            )
            rate = query_rate_converter.scalar() or 1
            invoice_sum = invoice_sum / rate
            return {
                'invoice_sum': str(
                    Decimal(invoice_sum).quantize(Decimal('.01'))
                ),
                'currency': account.currency.iso_code
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='info',
        context='..resources.invoices.Invoices',
        request_method='GET',
        renderer='travelcrm:templates/invoices/info.mak',
        permission='view'
    )
    def info(self):
        invoice = Invoice.get(self.request.params.get('id'))
        return {
            'title': _(u'Invoice Info'),
            'currency': invoice.account.currency.iso_code,
            'id': invoice.id
        }

    @view_config(
        name='services_info',
        context='..resources.invoices.Invoices',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def _services_info(self):
        invoice = Invoice.get(self.request.params.get('id'))
        bound_resource = (
            query_resource_data()
            .filter(Invoice.id == invoice.id)
            .first()
        )
        resource = Resource.get(bound_resource.resource_id)
        source_cls = get_resource_class(resource.resource_type.name)
        factory = source_cls.get_invoice_factory()
        query = factory.services_info(
            bound_resource.resource_id, invoice.account.currency.id
        )
        total_cnt = sum(row.cnt for row in query)
        total_sum = sum(row.price for row in query)
        return {
            'rows': query_serialize(query),
            'footer': [{
                'name': _(u'total'),
                'cnt': total_cnt,
                'price': format_decimal(total_sum, locale=get_locale_name())
            }]
        }

    @view_config(
        name='accounts_items_info',
        context='..resources.invoices.Invoices',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def _accounts_items_info(self):
        invoice = Invoice.get(self.request.params.get('id'))
        bound_resource = (
            query_resource_data()
            .filter(Invoice.id == invoice.id)
            .first()
        )
        resource = Resource.get(bound_resource.resource_id)
        source_cls = get_resource_class(resource.resource_type.name)
        factory = source_cls.get_invoice_factory()
        query = factory.accounts_items_info(
            bound_resource.resource_id, invoice.account.currency.id
        )
        total_cnt = sum(row.cnt for row in query)
        total_sum = sum(row.price for row in query)
        return {
            'rows': query_serialize(query),
            'footer': [{
                'name': _(u'total'),
                'cnt': total_cnt,
                'price': format_decimal(total_sum, locale=get_locale_name())
            }]
        }

    @view_config(
        name='payments_info',
        context='..resources.invoices.Invoices',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def _payments_info(self):
        query = query_invoice_payments(self.request.params.get('id'))
        total_sum = sum(row.sum for row in query)
        return {
            'rows': query_serialize(query),
            'footer': [{
                'date': _(u'total'),
                'sum': format_decimal(total_sum, locale=get_locale_name())
            }]
        }
