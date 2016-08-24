# -*coding: utf-8-*-

from datetime import datetime, timedelta

from sqlalchemy import func

from ...models.resource import Resource
from ...models.order import Order
from ...models.order_item import OrderItem
from ...models.country import Country
from ...models.tour import Tour
from ...models.hotel import Hotel
from ...models.location import Location
from ...models.region import Region
from ...lib.qb import ResourcesQueryBuilder


class CountriesStatsQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(CountriesStatsQueryBuilder, self).__init__(context)
        
        self._fields = {
            'iso_code': Country.iso_code,
            'quan': func.count(Country.id),
        }
        self.build_query()


    def build_query(self):
        self.build_base_query()
        self.query = (
            self.query
            .join(Order, Resource.order)
            .join(OrderItem, Order.orders_items)
            .join(Tour, OrderItem.tour)
            .join(Hotel, Tour.hotel)
            .join(Location, Hotel.location)
            .join(Region, Location.region)
            .join(Country, Region.country)
            .filter(
                Order.condition_status_success()
            )
            .group_by(Country.id)
        )
        super(CountriesStatsQueryBuilder, self).build_query()
        self.query = self.query.with_entities(
            Country.iso_code, func.count(Country.id).label('quan')
        )

    def advanced_search(self, **kwargs):
        super(CountriesStatsQueryBuilder, self).advanced_search(**kwargs)
        if 'period' in kwargs:
            self._filter_period(
                kwargs.get('period')
            )
    
    def _filter_period(self, period):
        if period:
            dt = datetime.today() - timedelta(days=period)
            self.query = self.query.filter(
                Order.deal_date >= dt
            )
