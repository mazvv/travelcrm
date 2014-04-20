# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.address import Address
from ..lib.qb.addresses import AddressesQueryBuilder
from ..lib.utils.common_utils import translate as _
from ..lib.utils.common_utils import translate as _

from ..forms.addresses import AddressSchema


log = logging.getLogger(__name__)


class Addresses(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.addresses.Addresses',
        request_method='GET',
        renderer='travelcrm:templates/addresses/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.addresses.Addresses',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def _list(self):
        qb = AddressesQueryBuilder(self.context)
        qb.search_simple(
            self.request.params.get('q')
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
        context='..resources.addresses.Addresses',
        request_method='GET',
        renderer='travelcrm:templates/addresses/form.mak',
        permission='add'
    )
    def add(self):
        return {
            'title': _(u'Add Address'),
        }

    @view_config(
        name='add',
        context='..resources.addresses.Addresses',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        schema = AddressSchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params)
            address = Address(
                location_id=controls.get('location_id'),
                zip_code=controls.get('zip_code'),
                address=controls.get('address'),
                resource=self.context.create_resource(controls.get('status'))
            )
            DBSession.add(address)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': address.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.addresses.Addresses',
        request_method='GET',
        renderer='travelcrm:templates/addresses/form.mak',
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
        context='..resources.addresses.Addresses',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        schema = AddressSchema().bind(request=self.request)
        address = Address.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params)
            address.location_id = controls.get('location_id')
            address.zip_code = controls.get('zip_code')
            address.address = controls.get('address')
            address.resource.status = controls.get('status')
            return {
                'success_message': _(u'Saved'),
                'response': address.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='copy',
        context='..resources.addresses.Addresses',
        request_method='GET',
        renderer='travelcrm:templates/addresses/form.mak',
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
        context='..resources.addresses.Addresses',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _copy(self):
        return self._add()

    @view_config(
        name='delete',
        context='..resources.addresses.Addresses',
        request_method='GET',
        renderer='travelcrm:templates/addresses/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'id': self.request.params.get('id')
        }

    @view_config(
        name='delete',
        context='..resources.addresses.Addresses',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        for id in self.request.params.getall('id'):
            address = Address.get(id)
            if address:
                DBSession.delete(address)
        return {'success_message': _(u'Deleted')}
