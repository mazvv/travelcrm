# -*coding: utf-8-*-
from collections import Iterable
from sqlalchemy import func, cast, DATE, distinct

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


class ToursQueryBuilder(ResourcesQueryBuilder):
    _subq = (
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
        )
        .join(Location, TourPoint.location)
        .join(Region, Location.region)
        .join(Country, Region.country)
        .outerjoin(Hotel, TourPoint.hotel)
        .outerjoin(Hotelcat, Hotel.hotelcat)
        .group_by(TourPoint.tour_id)
        .subquery()
    )

    _fields = {
        'id': Tour.id,
        '_id': Tour.id,
        'touroperator_name': Touroperator.name,
        'hotel_cat': _subq.c.hotel_cat,
        'country': _subq.c.country,
        'price': Tour.price,
        'currency': Currency.iso_code,
        'adults': Tour.adults,
        'children': Tour.children,
        'start_date': cast(Tour.start_date, DATE),
        'end_date': cast(Tour.end_date, DATE)
    }

    _simple_search_fields = [
        Touroperator.name,
    ]

    def __init__(self, context):
        super(ToursQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = (
            self.query
            .join(Tour, Resource.tour)
            .join(Touroperator, Tour.touroperator)
            .join(Currency, Tour.currency)
            .join(self._subq, Tour.id == self._subq.c.tour_id)
        )
        self.query = self.query.add_columns(*fields)

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Tour.id.in_(id))


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
