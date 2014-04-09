# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.tour import Tour
from ..models.tour_point import TourPoint
from ..lib.qb.tours import (
    ToursQueryBuilder,
    ToursPointsQueryBuilder,
)

from ..forms.tours import (
    TourSchema,
    TourPointSchema
)


log = logging.getLogger(__name__)


class Tours(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.tours.Tours',
        request_method='GET',
        renderer='travelcrm:templates/tours/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.tours.Tours',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        qb = ToursQueryBuilder(self.context)
        qb.search_simple(
            self.request.params.get('q'),
        )
        qb.advanced_search(
            updated_from=self.request.params.get('updated_from'),
            updated_to=self.request.params.get('updated_to'),
            modifier_id=self.request.params.get('modifier_id'),
            status=self.request.params.get('status'),
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
        context='..resources.tours.Tours',
        request_method='GET',
        renderer='travelcrm:templates/tours/form.mak',
        permission='add'
    )
    def add(self):
        _ = self.request.translate
        return {
            'title': _(u'Add Tour'),
        }

    @view_config(
        name='add',
        context='..resources.tours.Tours',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        _ = self.request.translate
        schema = TourSchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params.mixed())
            tour = Tour(
                touroperator_id=controls.get('touroperator_id'),
                adults=controls.get('adults'),
                children=controls.get('children'),
                price=controls.get('price'),
                currency_id=controls.get('currency_id'),
                start_location_id=controls.get('start_location_id'),
                end_location_id=controls.get('end_location_id'),
                start_dt=controls.get('start_dt'),
                end_dt=controls.get('end_dt'),
                resource=self.context.create_resource(controls.get('status'))
            )
            for point in controls.get('tour_point_id', []):
                point = TourPoint.get(point)
                tour.points.append(point)
            DBSession.add(tour)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': tour.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.tours.Tours',
        request_method='GET',
        renderer='travelcrm:templates/tours/form.mak',
        permission='edit'
    )
    def edit(self):
        _ = self.request.translate
        tour = Tour.get(self.request.params.get('id'))
        return {
            'item': tour,
            'title': _(u'Edit Business Person'),
        }

    @view_config(
        name='edit',
        context='..resources.tours.Tours',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        _ = self.request.translate
        schema = TourSchema().bind(request=self.request)
        tour = Tour.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params.mixed())
            tour.touroperator_id = controls.get('touroperator_id')
            tour.adults = controls.get('adults')
            tour.children = controls.get('children')
            tour.price = controls.get('price')
            tour.currency_id = controls.get('currency_id')
            tour.start_location_id = controls.get('start_location_id')
            tour.end_location_id = controls.get('end_location_id')
            tour.start_dt = controls.get('start_dt')
            tour.end_dt = controls.get('end_dt')
            tour.resource.status = controls.get('status')
            tour.points = []
            for point in controls.get('tour_point_id', []):
                point = TourPoint.get(point)
                tour.points.append(point)
            return {
                'success_message': _(u'Saved'),
                'response': tour.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='copy',
        context='..resources.tours.Tours',
        request_method='GET',
        renderer='travelcrm:templates/tours/form.mak',
        permission='add'
    )
    def copy(self):
        _ = self.request.translate
        tour = Tour.get(self.request.params.get('id'))
        return {
            'item': tour,
            'title': _(u"Copy Business Person")
        }

    @view_config(
        name='copy',
        context='..resources.tours.Tours',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _copy(self):
        return self._add()

    @view_config(
        name='delete',
        context='..resources.tours.Tours',
        request_method='GET',
        renderer='travelcrm:templates/tours/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'id': self.request.params.get('id')
        }

    @view_config(
        name='delete',
        context='..resources.tours.Tours',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        _ = self.request.translate
        for id in self.request.params.getall('id'):
            tour = Tour.get(id)
            if tour:
                DBSession.delete(tour)
        return {'success_message': _(u'Deleted')}

    @view_config(
        name='points',
        context='..resources.tours.Tours',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def points(self):
        qb = ToursPointsQueryBuilder()
        id = self.request.params.get('id')
        not_bound = self.request.params.get('not_bound')
        if id:
            qb.filter_id(id.split(','))
        if not_bound:
            qb.filter_not_bound()
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
        name='add_point',
        context='..resources.tours.Tours',
        request_method='GET',
        renderer='travelcrm:templates/tours/form_point.mak',
        permission='add'
    )
    def add_point(self):
        _ = self.request.translate
        return {
            'title': _(u'Add Tour Point'),
        }

    @view_config(
        name='add_point',
        context='..resources.tours.Tours',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add_point(self):
        _ = self.request.translate
        schema = TourPointSchema().bind(request=self.request)

        try:
            controls = schema.deserialize(self.request.params)
            point = TourPoint(
                location_id=controls.get('location_id'),
                hotel_id=controls.get('hotel_id'),
                accomodation_id=controls.get('accomodation_id'),
                foodcat_id=controls.get('foodcat_id'),
                roomcat_id=controls.get('roomcat_id'),
                start_dt=controls.get('start_dt'),
                end_dt=controls.get('end_dt'),
                description=controls.get('description'),
            )
            DBSession.add(point)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': point.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit_point',
        context='..resources.tours.Tours',
        request_method='GET',
        renderer='travelcrm:templates/tours/form_point.mak',
        permission='edit'
    )
    def edit_point(self):
        _ = self.request.translate
        point = TourPoint.get(self.request.params.get('id'))
        return {
            'item': point,
            'title': _(u'Edit Tour Point'),
        }

    @view_config(
        name='edit_point',
        context='..resources.tours.Tours',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit_point(self):
        _ = self.request.translate
        schema = TourPointSchema().bind(request=self.request)
        point = TourPoint.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params)
            point.location_id = controls.get('location_id')
            point.hotel_id = controls.get('hotel_id')
            point.accomodation_id = controls.get('accomodation_id')
            point.foodcat_id = controls.get('foodcat_id')
            point.roomcat_id = controls.get('roomcat_id')
            point.start_dt = controls.get('start_dt')
            point.end_dt = controls.get('end_dt')
            return {'success_message': _(u'Saved')}
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }
