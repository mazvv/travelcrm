# -*coding: utf-8-*-

from datetime import datetime, timedelta

from sqlalchemy import func

from ...models.resource import Resource
from ...models.order import Order 
from ...lib.qb import ResourcesQueryBuilder


class OrdersStatsQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(OrdersStatsQueryBuilder, self).__init__(context)
        
        self._fields = {
            'date': Order.deal_date,
            'quan': func.count(Order.id),
        }
        self.build_query()


    def build_query(self):
        self.build_base_query()
        self.query = (
            self.query
            .join(Order, Resource.order)
            .group_by(Order.deal_date)
        )
        super(OrdersStatsQueryBuilder, self).build_query()
        self.query = self.query.with_entities(
            Order.deal_date, func.count(Order.id).label('quan')
        )

    def advanced_search(self, **kwargs):
        super(OrdersStatsQueryBuilder, self).advanced_search(**kwargs)
        if 'period' in kwargs:
            self._filter_order_period(
                kwargs.get('period')
            )
    
    def _filter_order_period(self, period):
        if period:
            dt = datetime.today() - timedelta(days=period)
            self.query = self.query.filter(
                Order.deal_date >= dt
            )
