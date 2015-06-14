# -*-coding: utf-8-*-

import logging

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound

from ..models import DBSession
from ..models.spassport import Spassport
from ..models.order_item import OrderItem

from ..lib.utils.common_utils import translate as _
from ..forms.spassports import SpassportForm


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.spassports.SpassportsResource',
)
class SpassportsView(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        name='view',
        request_method='GET',
        renderer='travelcrm:templates/spassports/form.mako',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            spassport = Spassport.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': spassport.id}
                )
            )
        result = self.edit()
        result.update({
            'title': _(u"View Passport Sale"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        request_method='GET',
        renderer='travelcrm:templates/spassports/form.mako',
        permission='add'
    )
    def add(self):
        return {
            'title': _(u'Add Passport Service'),
        }

    @view_config(
        name='add',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        form = SpassportForm(self.request)
        if form.validate():
            spassport = form.submit()
            DBSession.add(spassport)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': spassport.order_item.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='edit',
        request_method='GET',
        renderer='travelcrm:templates/spassports/form.mako',
        permission='edit'
    )
    def edit(self):
        order_item = OrderItem.get(self.request.params.get('id'))
        return {
            'item': order_item.spassport,
            'title': _(u'Edit Passport Sale'),
        }

    @view_config(
        name='edit',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        order_item = OrderItem.get(self.request.params.get('id'))
        form = SpassportForm(self.request)
        if form.validate():
            form.submit(order_item.spassport)
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
        renderer='travelcrm:templates/spassports/form.mako',
        permission='add'
    )
    def copy(self):
        order_item = OrderItem.get(self.request.params.get('id'))
        return {
            'item': order_item.spassport,
            'title': _(u"Copy Service")
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
        renderer='travelcrm:templates/spassports/details.mako',
        permission='view'
    )
    def details(self):
        order_item = OrderItem.get(self.request.params.get('id'))
        return {
            'item': order_item.spassport,
        }
