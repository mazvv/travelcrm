# -*coding: utf-8-*-
from collections import Iterable

from babel.dates import parse_date
from sqlalchemy import func, cast, DATE, distinct, desc, or_, and_, literal
from sqlalchemy.dialects.postgresql import Any

from . import (
    ResourcesQueryBuilder,
    GeneralQueryBuilder
)

from ...models import DBSession
from ...models.resource import Resource
from ...models.tour import Tour
from ...models.tour_point import TourPoint
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

from ...lib.bl.currencies_rates import query_convert_rates_to_base
from ...lib.bl.persons import query_person_contacts, query_person_passports
from ...lib.utils.common_utils import get_locale_name, get_base_currency


class ToursQueryBuilder(ResourcesQueryBuilder):
    _subq_points = (
        DBSession.query(
            TourPoint.tour_id,
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
        .join(Location, TourPoint.location)
        .join(Region, Location.region)
        .join(Country, Region.country)
        .outerjoin(Hotel, TourPoint.hotel)
        .outerjoin(Hotelcat, Hotel.hotelcat)
        .group_by(TourPoint.tour_id)
        .subquery()
    )

    _subq_members = (
        DBSession.query(
            Tour.id.label('tour_id'),
            func.array_agg(distinct(Person.id)).label('person_arr'),
        )
        .join(Person, Tour.persons)
        .group_by(Tour.id)
        .subquery()
    )

    _subq_currencies_rates = (
        query_convert_rates_to_base(Tour.currency_id, Tour.deal_date)
        .subquery()
    )

    _subq_customer_contacts = query_person_contacts().subquery()
    _subq_customer_passports = query_person_passports().subquery()

    _fields = {
        'id': Tour.id,
        '_id': Tour.id,
        'deal_date': Tour.deal_date,
        'touroperator_name': Touroperator.name,
        'hotel_cat': _subq_points.c.hotel_cat,
        'country': _subq_points.c.country,
        'price': Tour.price,
        'currency': Currency.iso_code,
        'base_price': (
            Tour.price * func.coalesce(_subq_currencies_rates.c.rate, 1)
        ),
        'rate': func.coalesce(_subq_currencies_rates.c.rate, 1),
        'rate_date': _subq_currencies_rates.c.date,
        'adults': Tour.adults,
        'children': Tour.children,
        'start_date': cast(Tour.start_date, DATE),
        'end_date': cast(Tour.end_date, DATE),
        'customer': Person.name,
        'customer_phone': _subq_customer_contacts.c.phone,
        'customer_skype': _subq_customer_contacts.c.skype,
        'customer_email': _subq_customer_contacts.c.email,
        'customer_citizen_passport': _subq_customer_passports.c.citizen,
        'customer_foreign_passport': _subq_customer_passports.c.foreign,
    }

    _simple_search_fields = [
        Touroperator.name,
    ]

    def __init__(self, context):
        super(ToursQueryBuilder, self).__init__(context)
        self._fields['base_currency'] = literal(get_base_currency())
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = (
            self.query
            .join(Tour, Resource.tour)
            .join(Person, Tour.customer)
            .join(Touroperator, Tour.touroperator)
            .join(Currency, Tour.currency)
            .join(self._subq_points, Tour.id == self._subq_points.c.tour_id)
            .join(self._subq_members, Tour.id == self._subq_members.c.tour_id)
            .outerjoin(
                self._subq_customer_contacts,
                Tour.customer_id == self._subq_customer_contacts.c.person_id
            )
            .outerjoin(
                self._subq_customer_passports,
                Tour.customer_id == self._subq_customer_passports.c.person_id
            )
        )
        self.query = self.query.add_columns(*fields)

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Tour.id.in_(id))

    def advanced_search(self, updated_from, updated_to, modifier_id, **kwargs):
        super(ToursQueryBuilder, self).advanced_search(
            updated_from, updated_to, modifier_id
        )
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
                    Tour.customer_id == person_id
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
            self.query = self.query.filter(Tour.price >= price_from)
        if price_to:
            self.query = self.query.filter(Tour.price <= price_to)

    def _filter_tour_date(self, date_from, date_to):
        if date_from:
            self.query = self.query.filter(
                Tour.start_date >= parse_date(
                    date_from, locale=get_locale_name()
                )
            )
        if date_to:
            self.query = self.query.filter(
                Tour.end_date <= parse_date(
                    date_to, locale=get_locale_name()
                )
            )


class ToursPointsQueryBuilder(GeneralQueryBuilder):
    _fields = {
        'id': TourPoint.id,
        '_id': TourPoint.id,
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
        'point_start_date': TourPoint.start_date,
        'point_end_date': TourPoint.end_date,
        'description': TourPoint.description
    }

    def __init__(self):
        fields = GeneralQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = (
            DBSession.query(*fields)
            .outerjoin(Location, TourPoint.location)
            .outerjoin(Region, Location.region)
            .outerjoin(Country, Region.country)
            .outerjoin(Hotel, TourPoint.hotel)
            .outerjoin(Accomodation, TourPoint.accomodation)
            .outerjoin(Foodcat, TourPoint.foodcat)
            .outerjoin(Roomcat, TourPoint.roomcat)
            .outerjoin(Hotelcat, Hotel.hotelcat)
        )

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(TourPoint.id.in_(id))

    def filter_not_bound(self):
        self.query = self.query.filter(TourPoint.tour_id == None)
