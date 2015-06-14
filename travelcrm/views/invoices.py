# -*-coding: utf-8-*-

import logging

import colander
from babel.numbers import format_decimal

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound

from ..models import DBSession
from ..models.order import Order
from ..models.invoice import Invoice
from ..models.resource import Resource
from ..lib.qb import query_serialize
from ..lib.utils.common_utils import serialize
from ..lib.utils.common_utils import translate as _

from ..forms.invoices import (
    InvoiceForm,
    InvoiceSearchForm,
    InvoiceSumForm,
    InvoiceActiveUntilForm,
    InvoiceSettingsForm,
)

from ..lib.utils.resources_utils import (
    get_resource_class,
    get_resource_type_by_resource
)
from ..lib.utils.common_utils import get_locale_name
from ..lib.bl.invoices import (
    query_resource_data,
    query_invoice_payments,
)
from ..lib.bl.invoices import get_factory_by_invoice_id

log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.invoices.InvoicesResource',
)
class InvoicesView(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/invoices/index.mako',
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
        form = InvoiceSearchForm(self.request, self.context)
        form.validate()
        qb = form.submit()
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized()
        }

    @view_config(
        name='view',
        request_method='GET',
        renderer='travelcrm:templates/invoices/form.mako',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            invoice = Invoice.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': invoice.id}
                )
            )
        result = self.edit()
        result.update({
            'title': _(u"View Invoice"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        request_method='GET',
        renderer='travelcrm:templates/invoices/form.mako',
        permission='add'
    )
    def add(self):
        order = Order.get(self.request.params.get('id'))
        if order and order.invoice:
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'edit', query={'id': order.invoice.id}
                ),
            )
        return {
            'title': _(u'Add Invoice'),
            'order_id': order.id if order else None,
        }

    @view_config(
        name='add',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        form = InvoiceForm(self.request)
        if form.validate():
            invoice = form.submit()
            DBSession.add(invoice)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': invoice.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='edit',
        request_method='GET',
        renderer='travelcrm:templates/invoices/form.mako',
        permission='edit'
    )
    def edit(self):
        invoice = Invoice.get(self.request.params.get('id'))
        return {
            'item': invoice,
            'title': _(u'Edit Invoice')
        }

    @view_config(
        name='edit',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        invoice = Invoice.get(self.request.params.get('id'))
        form = InvoiceForm(self.request)
        if form.validate():
            form.submit(invoice)
            return {
                'success_message': _(u'Saved'),
                'response': invoice.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='details',
        request_method='GET',
        renderer='travelcrm:templates/invoices/details.mako',
        permission='view'
    )
    def details(self):
        invoice = Invoice.get(self.request.params.get('id'))
        return {
            'item': invoice,
        }

    @view_config(
        name='delete',
        request_method='GET',
        renderer='travelcrm:templates/invoices/delete.mako',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Invoices'),
            'rid': self.request.params.get('rid')
        }

    @view_config(
        name='delete',
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
        name='print',
        request_method='GET',
        renderer='travelcrm:templates/invoices/print.mako',
        permission='view',
    )
    def print_invoice(self):
        invoice = Invoice.get(self.request.params.get('id'))
        factory = get_factory_by_invoice_id(invoice.id)
        bound_resource = (
            query_resource_data()
            .filter(Invoice.id == invoice.id)
            .first()
        )
        payment_query = query_invoice_payments(self.request.params.get('id'))
        payment_sum = sum(row.sum for row in payment_query)
        return {
            'invoice': invoice,
            'factory': factory,
            'resource_id': bound_resource.resource_id,
            'payment_sum': payment_sum,
        }

    @view_config(
        name='invoice_sum',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def invoice_sum(self):
        form = InvoiceSumForm(self.request)
        if form.validate():
            invoice_sum = form.submit()
            return {
                'invoice_sum': serialize(invoice_sum),
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='invoice_active_until',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def invoice_active_until(self):
        form = InvoiceActiveUntilForm(self.request)
        if form.validate():
            active_until = form.submit()
            return {
                'active_until': serialize(active_until)
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='info',
        request_method='GET',
        renderer='travelcrm:templates/invoices/info.mako',
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
                'unit_price': None,
                'cnt': total_cnt,
                'price': format_decimal(total_sum, locale=get_locale_name()),
            }]
        }

    @view_config(
        name='payments_info',
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

    @view_config(
        name='settings',
        request_method='GET',
        renderer='travelcrm:templates/invoices/settings.mako',
        permission='settings',
    )
    def settings(self):
        rt = get_resource_type_by_resource(self.context)
        return {
            'title': _(u'Settings'),
            'rt': rt,
        }

    @view_config(
        name='settings',
        request_method='POST',
        renderer='json',
        permission='settings',
    )
    def _settings(self):
        form = InvoiceSettingsForm(self.request)
        if form.validate():
            form.submit()
            return {'success_message': _(u'Saved')}
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }
