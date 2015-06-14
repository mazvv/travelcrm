# -*-coding: utf-8-*-

import logging

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound

from ..models import DBSession
from ..models.ticket import Ticket
from ..models.order_item import OrderItem

from ..lib.utils.common_utils import translate as _
from ..forms.tickets import (
    TicketForm,
)


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.tickets.TicketsResource',
)
class TicketsView(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        name='view',
        request_method='GET',
        renderer='travelcrm:templates/tickets/form.mako',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            ticket = Ticket.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': ticket.id}
                )
            )
        result = self.edit()
        result.update({
            'title': _(u"View Ticket Sale"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        request_method='GET',
        renderer='travelcrm:templates/tickets/form.mako',
        permission='add'
    )
    def add(self):
        return {
            'title': _(u'Add Ticket'),
        }

    @view_config(
        name='add',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        form = TicketForm(self.request)
        if form.validate():
            ticket = form.submit()
            DBSession.add(ticket)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': ticket.order_item.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='edit',
        request_method='GET',
        renderer='travelcrm:templates/tickets/form.mako',
        permission='edit'
    )
    def edit(self):
        order_item = OrderItem.get(self.request.params.get('id'))
        return {
            'item': order_item.ticket,
            'title': _(u'Edit Ticket Sale'),
        }

    @view_config(
        name='edit',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        order_item = OrderItem.get(self.request.params.get('id'))
        form = TicketForm(self.request)
        if form.validate():
            form.submit(order_item.ticket)
            return {
                'success_message': _(u'Saved'),
                'response': order_item.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='copy',
        request_method='GET',
        renderer='travelcrm:templates/tickets/form.mako',
        permission='add'
    )
    def copy(self):
        order_item = OrderItem.get(self.request.params.get('id'))
        return {
            'item': order_item.ticket,
            'title': _(u"Copy Ticket")
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
        renderer='travelcrm:templates/tickets/details.mako',
        permission='view'
    )
    def details(self):
        order_item = OrderItem.get(self.request.params.get('id'))
        return {
            'item': order_item.ticket,
        }
