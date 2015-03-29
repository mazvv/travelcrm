# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound

from ..models import DBSession
from ..models.tour_sale import TourSale
from ..models.tour_sale_point import TourSalePoint
from ..models.person import Person
from ..models.note import Note
from ..models.task import Task
from ..models.service_item import ServiceItem
from ..lib.qb.tour_sale import (
    TourSaleQueryBuilder,
    TourSalePointQueryBuilder,
)
from ..resources.invoice import InvoiceResource
from ..resources.calculation import CalculationResource
from ..resources.service_item import ServiceItemResource

from ..lib.bl.currencies_rates import currency_base_exchange
from ..lib.utils.common_utils import translate as _
from ..lib.utils.resources_utils import (
    get_resource_type_by_resource,
)
from ..forms.tour_sale import (
    TourSaleSchema,
    TourSalePointSchema,
    TourSaleSearchSchema,
    SettingsSchema,
)


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.tour_sale.TourSaleResource',
)
class TourSaleView(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/tours_sales/index.mak',
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
        schema = TourSaleSearchSchema().bind(request=self.request)
        controls = schema.deserialize(self.request.params.mixed())
        qb = TourSaleQueryBuilder(self.context)
        qb.search_simple(controls.get('q'))
        qb.advanced_search(**controls)
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
        name='view',
        request_method='GET',
        renderer='travelcrm:templates/tours_sales/form.mak',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            tour_sale = TourSale.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': tour_sale.id}
                )
            )
        result = self.edit()
        result.update({
            'title': _(u"View Tour Sale"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        request_method='GET',
        renderer='travelcrm:templates/tours_sales/form.mak',
        permission='add'
    )
    def add(self):
        return {
            'title': _(u'Add Tour Sale'),
        }

    @view_config(
        name='add',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        schema = TourSaleSchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params.mixed())
            settings = self.context.get_settings()
            tour_sale = TourSale(
                deal_date=controls.get('deal_date'),
                customer_id=controls.get('customer_id'),
                advsource_id=controls.get('advsource_id'),
                adults=controls.get('adults'),
                children=controls.get('children'),
                start_location_id=controls.get('start_location_id'),
                end_location_id=controls.get('end_location_id'),
                start_date=controls.get('start_date'),
                end_date=controls.get('end_date'),
                resource=self.context.create_resource()
            )
            tour_sale.service_item = ServiceItem(
                service_id=settings.get('service_id'),
                touroperator_id=controls.get('touroperator_id'),
                currency_id=controls.get('currency_id'),
                price=controls.get('price'),
                person_id=controls.get('customer_id'),
                base_price=currency_base_exchange(
                    controls.get('price'),
                    controls.get('currency_id'),
                    controls.get('deal_date'),
                ),
                resource=ServiceItemResource(self.request).create_resource()
            )
            for id in controls.get('tour_sale_point_id'):
                point = TourSalePoint.get(id)
                tour_sale.points.append(point)
            for id in controls.get('person_id'):
                person = Person.get(id)
                tour_sale.persons.append(person)
            for id in controls.get('note_id'):
                note = Note.get(id)
                tour_sale.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                tour_sale.resource.tasks.append(task)
            DBSession.add(tour_sale)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': tour_sale.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        request_method='GET',
        renderer='travelcrm:templates/tours_sales/form.mak',
        permission='edit'
    )
    def edit(self):
        tour_sale = TourSale.get(self.request.params.get('id'))
        return {
            'item': tour_sale,
            'title': _(u'Edit Tour Sale'),
        }

    @view_config(
        name='edit',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        schema = TourSaleSchema().bind(request=self.request)
        tour_sale = TourSale.get(self.request.params.get('id'))
        try:
            settings = self.context.get_settings()
            controls = schema.deserialize(self.request.params.mixed())
            tour_sale.deal_date = controls.get('deal_date')
            tour_sale.customer_id = controls.get('customer_id')
            tour_sale.advsource_id = controls.get('advsource_id')
            tour_sale.adults = controls.get('adults')
            tour_sale.children = controls.get('children')
            tour_sale.start_location_id = controls.get('start_location_id')
            tour_sale.end_location_id = controls.get('end_location_id')
            tour_sale.start_date = controls.get('start_date')
            tour_sale.end_date = controls.get('end_date')
            tour_sale.service_item.service_id = settings.get('service_id')
            tour_sale.service_item.touroperator_id = (
                controls.get('touroperator_id')
            )
            tour_sale.service_item.currency_id = (
                controls.get('currency_id')
            )
            tour_sale.service_item.price = controls.get('price')
            tour_sale.service_item.person_id = (
                controls.get('customer_id')
            )
            tour_sale.service_item.base_price = currency_base_exchange(
                controls.get('price'),
                controls.get('currency_id'),
                controls.get('deal_date'),
            )

            tour_sale.points = []
            tour_sale.persons = []
            tour_sale.resource.notes = []
            tour_sale.resource.tasks = []
            for point in controls.get('tour_sale_point_id', []):
                point = TourSalePoint.get(point)
                tour_sale.points.append(point)
            for id in controls.get('person_id'):
                person = Person.get(id)
                tour_sale.persons.append(person)
            for id in controls.get('note_id'):
                note = Note.get(id)
                tour_sale.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                tour_sale.resource.tasks.append(task)
            return {
                'success_message': _(u'Saved'),
                'response': tour_sale.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='copy',
        request_method='GET',
        renderer='travelcrm:templates/tours_sales/form.mak',
        permission='add'
    )
    def copy(self):
        tour_sale = TourSale.get(self.request.params.get('id'))
        return {
            'item': tour_sale,
            'title': _(u"Copy Tour Sale")
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
        renderer='travelcrm:templates/tours_sales/details.mak',
        permission='view'
    )
    def details(self):
        tour_sale = TourSale.get(self.request.params.get('id'))
        return {
            'item': tour_sale,
        }

    @view_config(
        name='delete',
        request_method='GET',
        renderer='travelcrm:templates/tours_sales/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Tours Sales'),
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
            item = TourSale.get(id)
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
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def points(self):
        qb = TourSalePointQueryBuilder()
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
        name='point_details',
        request_method='GET',
        renderer='travelcrm:templates/tours_sales/point_details.mak',
        permission='view'
    )
    def point_details(self):
        tour_sale_point = TourSalePoint.get(self.request.params.get('id'))
        return {
            'item': tour_sale_point,
        }

    @view_config(
        name='add_point',
        request_method='GET',
        renderer='travelcrm:templates/tours_sales/form_point.mak',
        permission='add'
    )
    def add_point(self):
        return {
            'title': _(u'Add Tour Sale Point'),
        }

    @view_config(
        name='add_point',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add_point(self):
        schema = TourSalePointSchema().bind(request=self.request)

        try:
            controls = schema.deserialize(self.request.params)
            point = TourSalePoint(
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
        request_method='GET',
        renderer='travelcrm:templates/tours_sales/form_point.mak',
        permission='edit'
    )
    def edit_point(self):
        point = TourSalePoint.get(self.request.params.get('id'))
        return {
            'item': point,
            'title': _(u'Edit Tour Sale Point'),
        }

    @view_config(
        name='edit_point',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit_point(self):
        schema = TourSalePointSchema().bind(request=self.request)
        point = TourSalePoint.get(self.request.params.get('id'))
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
        request_method='GET',
        permission='invoice'
    )
    def invoice(self):
        tour_sale = TourSale.get(self.request.params.get('id'))
        if tour_sale:
            return HTTPFound(
                self.request.resource_url(
                    InvoiceResource(self.request),
                    'add' if not tour_sale.invoice else 'edit',
                    query=(
                        {'resource_id': tour_sale.resource.id}
                        if not tour_sale.invoice
                        else {'id': tour_sale.invoice.id}
                    )
                )
            )

    @view_config(
        name='calculation',
        request_method='GET',
        permission='calculation'
    )
    def calculation(self):
        tour_sale = TourSale.get(self.request.params.get('id'))
        if tour_sale:
            return HTTPFound(
                self.request.resource_url(
                    CalculationResource(self.request),
                    query=(
                        {'resource_id': tour_sale.resource.id}
                    )
                )
            )

    @view_config(
        name='settings',
        request_method='GET',
        renderer='travelcrm:templates/tours_sales/settings.mak',
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
