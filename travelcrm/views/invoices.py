# -*-coding: utf-8-*-

import logging

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound

from . import BaseView
from ..models import DBSession
from ..models.order import Order
from ..models.invoice import Invoice
from ..lib.bl.subscriptions import subscribe_resource
from ..lib.utils.common_utils import serialize
from ..lib.utils.common_utils import translate as _
from ..forms.invoices import (
    InvoiceForm,
    InvoiceSearchForm,
    InvoiceAssignForm,
    InvoiceSumForm,
    InvoiceActiveUntilForm,
    InvoiceSettingsForm,
)
from ..lib.utils.resources_utils import get_resource_type_by_resource
from ..lib.utils.security_utils import get_auth_employee
from ..lib.bl.employees import get_employee_structure
from ..lib.events.resources import (
    ResourceCreated,
    ResourceChanged,
    ResourceDeleted,
)

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
            event = ResourceCreated(self.request, invoice)
            event.registry()
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
            event = ResourceChanged(self.request, invoice)
            event.registry()
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
        name='copy',
        request_method='GET',
        renderer='travelcrm:templates/invoices/form.mako',
        permission='add'
    )
    def copy(self):
        invoice = Invoice.get_copy(self.request.params.get('id'))
        return {
            'action': self.request.path_url,
            'item': invoice,
            'title': self._get_title(_(u'Copy')),
        }

    @view_config(
        name='copy',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _copy(self):
        return self._add()

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
        errors = False
        ids = self.request.params.getall('id')
        if ids:
            items = DBSession.query(Invoice).filter(
                Invoice.id.in_(ids)
            )
            for item in items:
                try:
                    DBSession.delete(item)
                    DBSession.flush()
                    event = ResourceDeleted(self.request, item)
                    event.registry()
                except:
                    errors=True
                    DBSession.rollback()
        if errors:
            return {
                'error_message': _(
                    u'Some objects could not be delete'
                ),
            }
        return {'success_message': _(u'Deleted')}

    @view_config(
        name='assign',
        request_method='GET',
        renderer='travelcrm:templates/invoices/assign.mako',
        permission='assign'
    )
    def assign(self):
        return {
            'id': self.request.params.get('id'),
            'title': self._get_title(_(u'Assign Maintainer')),
        }

    @view_config(
        name='assign',
        request_method='POST',
        renderer='json',
        permission='assign'
    )
    def _assign(self):
        form = InvoiceAssignForm(self.request)
        if form.validate():
            form.submit(self.request.params.getall('id'))
            return {
                'success_message': _(u'Assigned'),
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='print',
        request_method='GET',
        renderer='str',
        permission='view',
    )
    def print_invoice(self):
        invoice = Invoice.get(self.request.params.get('id'))
        employee = get_auth_employee(self.request)
        structure = get_employee_structure(employee)
        return {
            'invoice': invoice,
            'employee': employee,
            'structure': structure,
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

    @view_config(
        name='subscribe',
        request_method='GET',
        renderer='travelcrm:templates/invoices/subscribe.mako',
        permission='view'
    )
    def subscribe(self):
        return {
            'id': self.request.params.get('id'),
            'title': self._get_title(_(u'Subscribe')),
        }

    @view_config(
        name='subscribe',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def _subscribe(self):
        ids = self.request.params.getall('id')
        for id in ids:
            invoice = Invoice.get(id)
            subscribe_resource(self.request, invoice.resource)
        return {
            'success_message': _(u'Subscribed'),
        }
