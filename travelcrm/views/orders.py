# -*-coding: utf-8-*-

import logging

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound

from . import BaseView
from ..resources.invoices import InvoicesResource
from ..resources.calculations import CalculationsResource
from ..models import DBSession
from ..models.order import Order
from ..models.lead import Lead
from ..lib.bl.subscriptions import subscribe_resource
from ..lib.utils.common_utils import translate as _
from ..forms.orders import (
    OrderForm, 
    OrderSearchForm,
    OrderAssignForm,
    OrderSettingsForm,
)
from ..lib.utils.security_utils import get_auth_employee
from ..lib.utils.resources_utils import get_resource_type_by_resource
from ..lib.bl.employees import get_employee_structure
from ..lib.events.resources import (
    ResourceCreated,
    ResourceChanged,
    ResourceDeleted,
)


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.orders.OrdersResource',
)
class OrdersView(BaseView):

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/orders/index.mako',
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
        form = OrderSearchForm(self.request, self.context)
        form.validate()
        qb = form.submit()
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized()
        }

    @view_config(
        name='view',
        request_method='GET',
        renderer='travelcrm:templates/orders/form.mako',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            order = Order.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': order.id}
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
        renderer='travelcrm:templates/orders/form.mako',
        permission='add'
    )
    def add(self):
        lead = Lead.get(self.request.params.get('id'))
        return {
            'lead': lead,
            'title': self._get_title(_(u'Add')),
        }

    @view_config(
        name='add',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        form = OrderForm(self.request)
        if form.validate():
            order = form.submit()
            DBSession.add(order)
            DBSession.flush()
            event = ResourceCreated(self.request, order)
            event.registry()
            return {
                'success_message': _(u'Saved'),
                'response': order.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='edit',
        request_method='GET',
        renderer='travelcrm:templates/orders/form.mako',
        permission='edit'
    )
    def edit(self):
        sale_service = Order.get(self.request.params.get('id'))
        return {
            'item': sale_service,
            'title': self._get_title(_(u'Edit')),
        }

    @view_config(
        name='edit',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        order = Order.get(self.request.params.get('id'))
        form = OrderForm(self.request)
        if form.validate():
            form.submit(order)
            event = ResourceChanged(self.request, order)
            event.registry()
            return {
                'success_message': _(u'Saved'),
                'response': order.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='copy',
        request_method='GET',
        renderer='travelcrm:templates/orders/form.mako',
        permission='add'
    )
    def copy(self):
        order = Order.get_copy(self.request.params.get('id'))
        return {
            'action': self.request.path_url,
            'item': order,
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
        name='delete',
        request_method='GET',
        renderer='travelcrm:templates/orders/delete.mako',
        permission='delete'
    )
    def delete(self):
        return {
            'title': self._get_title(_(u'Delete')),
            'id': self.request.params.get('id')
        }

    @view_config(
        name='details',
        request_method='GET',
        renderer='travelcrm:templates/orders/details.mako',
        permission='view'
    )
    def details(self):
        order = Order.get(self.request.params.get('id'))
        return {
            'item': order,
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
            try:
                items = DBSession.query(Order).filter(
                    Order.id.in_(ids)
                )
                for item in items:
                    DBSession.delete(item)
                    event = ResourceDeleted(self.request, item)
                    event.registry()
                DBSession.flush()
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
        renderer='travelcrm:templates/orders/assign.mako',
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
        form = OrderAssignForm(self.request)
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
        name='invoice',
        request_method='GET',
        permission='invoice'
    )
    def invoice(self):
        order = Order.get(self.request.params.get('id'))
        if order:
            return HTTPFound(
                location = self.request.resource_url(
                    InvoicesResource(self.request),
                    'add' if not order.invoice else 'edit',
                    query={
                        'id': order.id 
                        if not order.invoice 
                        else order.invoice.id
                    }
                )
            )

    @view_config(
        name='calculation',
        request_method='GET',
        permission='calculation'
    )
    def calculation(self):
        order = Order.get(self.request.params.get('id'))
        if order:
            return HTTPFound(
                self.request.resource_url(
                    CalculationsResource(self.request),
                    query={'id': order.id}
                )
            )

    @view_config(
        name='print',
        request_method='GET',
        renderer='str',
        permission='view',
    )
    def print_invoice(self):
        order = Order.get(self.request.params.get('id'))
        employee = get_auth_employee(self.request)
        structure = get_employee_structure(employee)
        return {
            'order': order,
            'employee': employee,
            'structure': structure,
        }

    @view_config(
        name='settings',
        request_method='GET',
        renderer='travelcrm:templates/orders/settings.mako',
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
        form = OrderSettingsForm(self.request)
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
        renderer='travelcrm:templates/orders/subscribe.mako',
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
            order = Order.get(id)
            subscribe_resource(self.request, order.resource)
        return {
            'success_message': _(u'Subscribed'),
        }
