# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config
from pyramid.httpexceptions import HTTPFound

from ..models import DBSession
from ..models.tour import Tour
from ..models.tour_point import TourPoint
from ..models.person import Person
from ..models.service_item import ServiceItem
from ..lib.qb.tours import (
    ToursQueryBuilder,
    ToursPointsQueryBuilder,
)
from ..resources.invoices import Invoices
from ..resources.liabilities import Liabilities

from ..lib.bl.tours import calc_base_price
from ..lib.utils.common_utils import translate as _
from ..lib.utils.resources_utils import (
    get_resource_type_by_resource,
)
from ..forms.tours import (
    TourSchema,
    TourPointSchema,
    SettingsSchema,
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
            **self.request.params.mixed()
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
        schema = TourSchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params.mixed())
            settings = self.context.get_settings()
            tour = Tour(
                deal_date=controls.get('deal_date'),
                service_id=settings.get('service_id'),
                advsource_id=controls.get('advsource_id'),
                touroperator_id=controls.get('touroperator_id'),
                customer_id=controls.get('customer_id'),
                adults=controls.get('adults'),
                children=controls.get('children'),
                price=controls.get('price'),
                currency_id=controls.get('currency_id'),
                start_location_id=controls.get('start_location_id'),
                end_location_id=controls.get('end_location_id'),
                start_date=controls.get('start_date'),
                end_date=controls.get('end_date'),
                resource=self.context.create_resource()
            )
            for id in controls.get('tour_point_id'):
                point = TourPoint.get(id)
                tour.points.append(point)
            for id in controls.get('person_id'):
                person = Person.get(id)
                tour.persons.append(person)
            for id in controls.get('service_item_id'):
                service_item = ServiceItem.get(id)
                tour.services_items.append(service_item)
            tour = calc_base_price(tour)
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
        tour = Tour.get(self.request.params.get('id'))
        return {
            'item': tour,
            'title': _(u'Edit Tour'),
        }

    @view_config(
        name='edit',
        context='..resources.tours.Tours',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        schema = TourSchema().bind(request=self.request)
        tour = Tour.get(self.request.params.get('id'))
        try:
            settings = self.context.get_settings()
            controls = schema.deserialize(self.request.params.mixed())
            tour.deal_date = controls.get('deal_date')
            tour.advsource_id = controls.get('advsource_id')
            tour.service_id = settings.get('service_id'),
            tour.touroperator_id = controls.get('touroperator_id')
            tour.customer_id = controls.get('customer_id')
            tour.adults = controls.get('adults')
            tour.children = controls.get('children')
            tour.price = controls.get('price')
            tour.currency_id = controls.get('currency_id')
            tour.start_location_id = controls.get('start_location_id')
            tour.end_location_id = controls.get('end_location_id')
            tour.start_date = controls.get('start_date')
            tour.end_date = controls.get('end_date')
            tour.points = []
            tour.persons = []
            tour.services_items = []
            for point in controls.get('tour_point_id', []):
                point = TourPoint.get(point)
                tour.points.append(point)
            for id in controls.get('person_id'):
                person = Person.get(id)
                tour.persons.append(person)
            for id in controls.get('service_item_id'):
                service_item = ServiceItem.get(id)
                tour.services_items.append(service_item)
            tour = calc_base_price(tour)
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
        tour = Tour.get(self.request.params.get('id'))
        return {
            'item': tour,
            'title': _(u"Copy Tour")
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
        name='details',
        context='..resources.tours.Tours',
        request_method='GET',
        renderer='travelcrm:templates/tours/details.mak',
        permission='view'
    )
    def details(self):
        tour = Tour.get(self.request.params.get('id'))
        return {
            'item': tour,
        }

    @view_config(
        name='delete',
        context='..resources.tours.Tours',
        request_method='GET',
        renderer='travelcrm:templates/tours/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Tours'),
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
        errors = 0
        for id in self.request.params.getall('id'):
            item = Tour.get(id)
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
        schema = TourPointSchema().bind(request=self.request)

        try:
            controls = schema.deserialize(self.request.params)
            point = TourPoint(
                location_id=controls.get('location_id'),
                hotel_id=controls.get('hotel_id'),
                accomodation_id=controls.get('accomodation_id'),
                foodcat_id=controls.get('foodcat_id'),
                roomcat_id=controls.get('roomcat_id'),
                start_date=controls.get('start_date'),
                end_date=controls.get('end_date'),
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
        schema = TourPointSchema().bind(request=self.request)
        point = TourPoint.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params)
            point.location_id = controls.get('location_id')
            point.hotel_id = controls.get('hotel_id')
            point.accomodation_id = controls.get('accomodation_id')
            point.foodcat_id = controls.get('foodcat_id')
            point.roomcat_id = controls.get('roomcat_id')
            point.start_date = controls.get('start_date')
            point.end_date = controls.get('end_date')
            return {'success_message': _(u'Saved')}
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='invoice',
        context='..resources.tours.Tours',
        request_method='GET',
        permission='invoice'
    )
    def invoice(self):
        tour = Tour.get(self.request.params.get('id'))
        if tour:
            return HTTPFound(
                self.request.resource_url(
                    Invoices(self.request),
                    'add' if not tour.invoice else 'edit',
                    query=(
                        {'resource_id': tour.resource.id}
                        if not tour.invoice
                        else {'id': tour.invoice.id}
                    )
                )
            )

    @view_config(
        name='liability',
        context='..resources.tours.Tours',
        request_method='GET',
        permission='liability'
    )
    def liabilities(self):
        tour = Tour.get(self.request.params.get('id'))
        if tour:
            return HTTPFound(
                self.request.resource_url(
                    Liabilities(self.request),
                    'add' if not tour.liability else 'edit',
                    query=(
                        {'resource_id': tour.resource.id}
                    )
                )
            )

    @view_config(
        name='settings',
        context='..resources.tours.Tours',
        request_method='GET',
        renderer='travelcrm:templates/tours/settings.mak',
        permission='settings',
    )
    def settings(self):
        rt = get_resource_type_by_resource(self.context)
        return {
            'title': _(u'Settings'),
            'rt': rt,
        }

    @view_config(
        name='settings',
        context='..resources.tours.Tours',
        request_method='POST',
        renderer='json',
        permission='settings',
    )
    def _settings(self):
        schema = SettingsSchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params)
            rt = get_resource_type_by_resource(self.context)
            rt.settings = {'service_id': controls.get('service_id')}
            return {'success_message': _(u'Saved')}
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }
