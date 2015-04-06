# -*-coding: utf-8-*-

import logging

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound

from ..models import DBSession
from ..models.order import Order
from ..resources.invoice import InvoiceResource
from ..resources.calculation import CalculationResource

from ..lib.utils.common_utils import translate as _
from ..forms.order import (
    OrderForm, 
    OrderSearchForm
)


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.order.OrderResource',
)
class OrderView(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/order/index.mak',
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
        renderer='travelcrm:templates/order/form.mak',
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
            'title': _(u"View Order"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        request_method='GET',
        renderer='travelcrm:templates/order/form.mak',
        permission='add'
    )
    def add(self):
        return {
            'title': _(u'Add Order'),
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
        renderer='travelcrm:templates/order/form.mak',
        permission='edit'
    )
    def edit(self):
        sale_service = Order.get(self.request.params.get('id'))
        return {
            'item': sale_service,
            'title': _(u'Edit Service Sale'),
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
        renderer='travelcrm:templates/order/form.mak',
        permission='add'
    )
    def copy(self):
        order = Order.get(self.request.params.get('id'))
        return {
            'item': order,
            'title': _(u"Copy Service Sale")
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
        renderer='travelcrm:templates/order/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Services Sales'),
            'id': self.request.params.get('id')
        }

    @view_config(
        name='details',
        request_method='GET',
        renderer='travelcrm:templates/order/details.mak',
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
        errors = 0
        for id in self.request.params.getall('id'):
            item = Order.get(id)
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
        name='invoice',
        request_method='GET',
        permission='invoice'
    )
    def invoice(self):
        order = Order.get(self.request.params.get('id'))
        if order:
            return HTTPFound(
                self.request.resource_url(
                    InvoiceResource(self.request),
                    'add' if not order.invoice else 'edit',
                    query=(
                        {'resource_id': order.resource.id}
                        if not order.invoice
                        else {'id': order.invoice.id}
                    )
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
                    CalculationResource(self.request),
                    query=(
                        {'resource_id': order.resource.id}
                    )
                )
            )
