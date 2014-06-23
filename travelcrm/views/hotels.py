# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.hotel import Hotel
from ..lib.qb.hotels import HotelsQueryBuilder
from ..lib.utils.common_utils import translate as _

from ..forms.hotels import HotelSchema


log = logging.getLogger(__name__)


class Hotels(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.hotels.Hotels',
        request_method='GET',
        renderer='travelcrm:templates/hotels/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.hotels.Hotels',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        qb = HotelsQueryBuilder(self.context)
        qb.search_simple(
            self.request.params.get('q'),
        )
        qb.advanced_search(
            updated_from=self.request.params.get('updated_from'),
            updated_to=self.request.params.get('updated_to'),
            modifier_id=self.request.params.get('modifier_id'),
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
        context='..resources.hotels.Hotels',
        request_method='GET',
        renderer='travelcrm:templates/hotels/form.mak',
        permission='add'
    )
    def add(self):
        return {'title': _(u'Add Hotel')}

    @view_config(
        name='add',
        context='..resources.hotels.Hotels',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        schema = HotelSchema().bind(request=self.request)

        try:
            controls = schema.deserialize(self.request.params)
            hotel = Hotel(
                name=controls.get('name'),
                hotelcat_id=controls.get('hotelcat_id'),
                location_id=controls.get('location_id'),
                resource=self.context.create_resource()
            )
            DBSession.add(hotel)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': hotel.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.hotels.Hotels',
        request_method='GET',
        renderer='travelcrm:templates/hotels/form.mak',
        permission='edit'
    )
    def edit(self):
        hotel = Hotel.get(self.request.params.get('id'))
        return {'item': hotel, 'title': _(u'Edit Hotel')}

    @view_config(
        name='edit',
        context='..resources.hotels.Hotels',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        schema = HotelSchema().bind(request=self.request)
        hotel = Hotel.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params)
            hotel.name = controls.get('name')
            hotel.hotelcat_id = controls.get('hotelcat_id')
            hotel.location_id = controls.get('location_id')
            return {
                'success_message': _(u'Saved'),
                'response': hotel.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='copy',
        context='..resources.hotels.Hotels',
        request_method='GET',
        renderer='travelcrm:templates/hotels/form.mak',
        permission='add'
    )
    def copy(self):
        hotel = Hotel.get(self.request.params.get('id'))
        return {
            'item': hotel,
            'title': _(u"Copy Hotel")
        }

    @view_config(
        name='copy',
        context='..resources.hotels.Hotels',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _copy(self):
        return self._add()

    @view_config(
        name='delete',
        context='..resources.hotels.Hotels',
        request_method='GET',
        renderer='travelcrm:templates/hotels/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Hotels'),
            'rid': self.request.params.get('rid')
        }

    @view_config(
        name='delete',
        context='..resources.hotels.Hotels',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        errors = 0
        for id in self.request.params.getall('id'):
            item = Hotel.get(id)
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
