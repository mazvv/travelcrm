# -*-coding: utf-8-*-

import logging

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound

from . import BaseView
from ..models.order_item import OrderItem
from ..models.service import Service
from ..lib.utils.resources_utils import get_resource_class
from ..lib.utils.common_utils import translate as _

from ..forms.orders_items import OrderItemSearchForm


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.orders_items.OrdersItemsResource',
)
class OrdersItemsView(BaseView):

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/orders_items/index.mako',
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
    def _list(self):
        form = OrderItemSearchForm(self.request, self.context)
        form.validate()
        qb = form.submit()
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized()
        }

    @view_config(
        name='view',
        request_method='GET',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            order_item = OrderItem.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': order_item.id}
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
        permission='add'
    )
    def add(self):
        service = Service.get(self.request.params.get('id'))
        rt_cls = get_resource_class(service.resource_type.name)
        return HTTPFound(
            location=self.request.resource_url(
                rt_cls(self.request), 'add', query={'id': service.id}
            )
        )

    @view_config(
        name='edit',
        request_method='GET',
        permission='edit'
    )
    def edit(self):
        order_item = OrderItem.get(self.request.params.get('id'))
        rt_cls = get_resource_class(order_item.service.resource_type.name)
        return HTTPFound(
            location=self.request.resource_url(
                rt_cls(self.request), 'edit', query={'id': order_item.id}
            )
        )

    @view_config(
        name='copy',
        request_method='GET',
        permission='add'
    )
    def copy(self):
        order_item = OrderItem.get(self.request.params.get('id'))
        rt_cls = get_resource_class(order_item.service.resource_type.name)
        return HTTPFound(
            location=self.request.resource_url(
                rt_cls(self.request), 'copy', query={'id': order_item.id}
            )
        )

    @view_config(
        name='details',
        request_method='GET',
        permission='view'
    )
    def details(self):
        order_item = OrderItem.get(self.request.params.get('id'))
        rt_cls = get_resource_class(order_item.service.resource_type.name)
        return HTTPFound(
            location=self.request.resource_url(
                rt_cls(self.request), 'details', query={'id': order_item.id}
            )
        )

    @view_config(
        name='delete',
        request_method='GET',
        renderer='travelcrm:templates/orders_items/delete.mako',
        permission='delete'
    )
    def delete(self):
        return {
            'title': self._get_title(_(u'Delete')),
            'id': self.request.params.get('id')
        }
