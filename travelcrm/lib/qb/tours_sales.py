# -*coding: utf-8-*-
from collections import Iterable

from sqlalchemy import func, cast, DATE, distinct, or_, literal
from sqlalchemy.dialects.postgresql import Any

from . import (
    ResourcesQueryBuilder,
    GeneralQueryBuilder
)

from ...models import DBSession
from ...models.resource import Resource
from ...models.tour_sale import TourSale
from ...models.tour_sale_point import TourSalePoint
from ...models.service_item import ServiceItem
from ...models.touroperator import Touroperator
from ...models.location import Location
from ...models.region import Region
from ...models.country import Country
from ...models.accomodation import Accomodation
from ...models.foodcat import Foodcat
from ...models.roomcat import Roomcat
from ...models.hotelcat import Hotelcat
from ...models.hotel import Hotel
from ...models.currency import Currency
from ...models.person import Person
from ...models.invoice import Invoice

from ...lib.utils.common_utils import get_base_currency


class ToursSalesQueryBuilder(ResourcesQueryBuilder):
    _subq_points = (
        DBSession.query(
            TourSalePoint.tour_sale_id,
            func.array_to_string(
                func.array_agg(distinct(Hotelcat.name)),
                ', '
            )
            .label('hotel_cat'),
            func.array_to_string(
                func.array_agg(distinct(Country.name)),
                ', '
            )
            .label('country'),
            func.array_agg(distinct(Country.id)).label('country_arr'),
            func.array_agg(distinct(Hotelcat.id)).label('hotelcat_arr'),
            func.array_agg(distinct(Hotel.id)).label('hotel_arr'),
            func.array_agg(distinct(Region.id)).label('region_arr'),
        )
        .join(Location, TourSalePoint.location)
        .join(Region, Location.region)
        .join(Country, Region.country)
        .outerjoin(Hotel, TourSalePoint.hotel)
        .outerjoin(Hotelcat, Hotel.hotelcat)
        .group_by(TourSalePoint.tour_sale_id)
        .subquery()
    )

    _subq_members = (
        DBSession.query(
            TourSale.id.label('tour_sale_id'),
            func.array_agg(distinct(Person.id)).label('person_arr'),
        )
        .join(Person, TourSale.persons)
        .group_by(TourSale.id)
        .subquery()
    )

    _fields = {
        'id': TourSale.id,
        '_id': TourSale.id,
        'deal_date': TourSale.deal_date,
        'touroperator_name': Touroperator.name,
        'hotel_cat': _subq_points.c.hotel_cat,
        'country': _subq_points.c.country,
        'base_price': ServiceItem.base_price,
        'start_date': cast(TourSale.start_date, DATE),
        'end_date': cast(TourSale.end_date, DATE),
        'customer': Person.name,
        'invoice_id': Invoice.id,
    }

    _simple_search_fields = [
        Touroperator.name,
        Person.name,
    ]

    def __init__(self, context):
        super(ToursSalesQueryBuilder, self).__init__(context)
        self._fields['base_currency'] = literal(get_base_currency())
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = (
            self.query
            .join(TourSale, Resource.tour_sale)
            .join(ServiceItem, TourSale.service_item)
            .join(Person, TourSale.customer)
            .join(Touroperator, ServiceItem.touroperator)
            .join(Currency, ServiceItem.currency)
            .join(
                self._subq_points,
                TourSale.id == self._subq_points.c.tour_sale_id
            )
            .join(
                self._subq_members,
                TourSale.id == self._subq_members.c.tour_sale_id
            )
            .outerjoin(Invoice, TourSale.invoice)
        )
        self.query = self.query.add_columns(*fields)

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(TourSale.id.in_(id))

    def advanced_search(self, **kwargs):
        super(ToursSalesQueryBuilder, self).advanced_search(**kwargs)
        if 'person_id' in kwargs:
            self._filter_person(kwargs.get('person_id'))
        if 'hotel_id' in kwargs:
            self._filter_hotel(kwargs.get('hotel_id'))
        if 'hotelcat_id' in kwargs:
            self._filter_hotelcat(kwargs.get('hotelcat_id'))
        if 'country_id' in kwargs:
            self._filter_country(kwargs.get('country_id'))
        if 'region_id' in kwargs:
            self._filter_region(kwargs.get('region_id'))
        if 'price_from' in kwargs or 'price_to' in kwargs:
            self._filter_price(
                kwargs.get('price_from'), kwargs.get('price_to')
            )
        if 'tour_from' in kwargs or 'tour_to' in kwargs:
            self._filter_tour_date(
                kwargs.get('tour_from'), kwargs.get('tour_to')
            )

    def _filter_person(self, person_id):
        if person_id:
            self.query = self.query.filter(
                or_(
                    Any(int(person_id), self._subq_members.c.person_arr),
                    TourSale.customer_id == person_id
                )
            )

    def _filter_hotel(self, hotel_id):
        if hotel_id:
            self.query = self.query.filter(
                Any(int(hotel_id), self._subq_points.c.hotel_arr),
            )

    def _filter_hotelcat(self, hotelcat_id):
        if hotelcat_id:
            self.query = self.query.filter(
                Any(int(hotelcat_id), self._subq_points.c.hotelcat_arr),
            )

    def _filter_country(self, country_id):
        if country_id:
            self.query = self.query.filter(
                Any(int(country_id), self._subq_points.c.country_arr),
            )

    def _filter_region(self, region_id):
        if region_id:
            self.query = self.query.filter(
                Any(int(region_id), self._subq_points.c.region_arr),
            )

    def _filter_price(self, price_from, price_to):
        if price_from:
            self.query = (
                self.query.filter(ServiceItem.base_price >= price_from)
            )
        if price_to:
            self.query = (
                self.query.filter(ServiceItem.base_price <= price_to)
            )

    def _filter_tour_date(self, date_from, date_to):
        if date_from:
            self.query = self.query.filter(
                TourSale.start_date >= date_from
            )
        if date_to:
            self.query = self.query.filter(
                TourSale.end_date <= date_to
            )


class ToursSalesPointsQueryBuilder(GeneralQueryBuilder):
    _fields = {
        'id': TourSalePoint.id,
        '_id': TourSalePoint.id,
        'full_location_name': (
            Location.name + ' - ' + Region.name + ' (' + Country.name + ')'
        ),
        'hotel_name': Hotel.name,
        'hotelcat_name': Hotelcat.name,
        'country_name': Country.name,
        'full_hotel_name': Hotel.name + ' (' + Hotelcat.name + ')',
        'accomodation_name': Accomodation.name,
        'roomcat_name': Roomcat.name,
        'foodcat_name': Foodcat.name,
        'point_start_date': TourSalePoint.start_date,
        'point_end_date': TourSalePoint.end_date,
        'description': TourSalePoint.description
    }

    def __init__(self):
        fields = GeneralQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = (
            DBSession.query(*fields)
            .outerjoin(Location, TourSalePoint.location)
            .outerjoin(Region, Location.region)
            .outerjoin(Country, Region.country)
            .outerjoin(Hotel, TourSalePoint.hotel)
            .outerjoin(Accomodation, TourSalePoint.accomodation)
            .outerjoin(Foodcat, TourSalePoint.foodcat)
            .outerjoin(Roomcat, TourSalePoint.roomcat)
            .outerjoin(Hotelcat, Hotel.hotelcat)
        )

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(TourSalePoint.id.in_(id))

    def filter_not_bound(self):
        self.query = self.query.filter(TourSalePoint.tour_sale_id == None)
