# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder

from ...models.resource import Resource
from ...models.order import Order
from ...models.person import Person
from ...models.advsource import Advsource


class OrdersQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(OrdersQueryBuilder, self).__init__(context)
        self._fields = {
            'id': Order.id,
            '_id': Order.id,
            'deal_date': Order.deal_date,
            'customer': Person.name,
            'status': Order.status,
            'advsource': Advsource.name,
        }
        self._simple_search_fields = [
            Person.name,
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = (
            self.query
            .join(Order, Resource.order)
            .join(Person, Order.customer)
            .join(Advsource, Order.advsource)
        )
        super(OrdersQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Order.id.in_(id))
