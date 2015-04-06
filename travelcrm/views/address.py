# -*-coding: utf-8-*-

import logging

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound

from ..models import DBSession
from ..models.address import Address
from ..lib.utils.common_utils import translate as _

from ..forms.address import (
    AddressForm,
    AddressSearchForm,
)


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.address.AddressResource',
)
class AddressView(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/address/index.mak',
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
    def _list(self):
        form = AddressSearchForm(self.request, self.context)
        form.validate()
        qb = form.submit()
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized()
        }

    @view_config(
        name='view',
        request_method='GET',
        renderer='travelcrm:templates/address/form.mak',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            address = Address.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': address.id}
                )
            )
        result = self.edit()
        result.update({
            'title': _(u"View Address"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        request_method='GET',
        renderer='travelcrm:templates/address/form.mak',
        permission='add'
    )
    def add(self):
        return {
            'title': _(u'Add Address'),
        }

    @view_config(
        name='add',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        form = AddressForm(self.request)
        if form.validate():
            address = form.submit()
            DBSession.add(address)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': address.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='edit',
        request_method='GET',
        renderer='travelcrm:templates/address/form.mak',
        permission='edit'
    )
    def edit(self):
        address = Address.get(self.request.params.get('id'))
        return {
            'item': address,
            'title': _(u'Edit Address'),
        }

    @view_config(
        name='edit',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        address = Address.get(self.request.params.get('id'))
        form = AddressForm(self.request)
        if form.validate():
            form.submit(address)
            return {
                'success_message': _(u'Saved'),
                'response': address.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='copy',
        request_method='GET',
        renderer='travelcrm:templates/address/form.mak',
        permission='add'
    )
    def copy(self):
        address = Address.get(self.request.params.get('id'))
        return {
            'item': address,
            'title': _(u"Copy Address")
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
        renderer='travelcrm:templates/address/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Addresses'),
            'id': self.request.params.get('id')
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
            item = Address.get(id)
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
