# -*-coding: utf-8-*-

import logging

from pyramid.view import view_config, view_defaults
from pyramid.renderers import render
from pyramid.httpexceptions import HTTPFound

from . import BaseView
from ..models import DBSession
from ..models.order import Order
from ..models.invoice import Invoice
from ..lib.utils.common_utils import serialize
from ..lib.utils.common_utils import translate as _

from ..forms.invoices import (
    InvoiceForm,
    InvoiceSearchForm,
    InvoiceSumForm,
    InvoiceActiveUntilForm,
    InvoiceSettingsForm,
)
from ..lib.utils.resources_utils import get_resource_type_by_resource

log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.invoices.InvoicesResource',
)
class InvoicesView(BaseView):

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/invoices/index.mako',
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
            'title': self._get_title(_(u'View')),
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
            'title': self._get_title(_(u'Add')),
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
            'title': self._get_title(_(u'Edit')),
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
            'title': self._get_title(_(u'Delete')),
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
        renderer='pdf',
        permission='view',
    )
    def print_invoice(self):
        invoice = Invoice.get(self.request.params.get('id'))
        body = render(
            'travelcrm:templates/invoices/print.mako',
            {'invoice': invoice},
            self.request,
        )
        return {
            'body': body,
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
        name='settings',
        request_method='GET',
        renderer='travelcrm:templates/invoices/settings.mako',
        permission='settings',
    )
    def settings(self):
        rt = get_resource_type_by_resource(self.context)
        return {
            'title': self._get_title(_(u'Settings')),
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
