# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder

from ...models.resource import Resource
from ...models.order_item import OrderItem
from ...models.service import Service
from ...models.currency import Currency
from ...models.supplier import Supplier


class OrdersItemsQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(OrdersItemsQueryBuilder, self).__init__(context)
        self._fields = {
            'id': OrderItem.id,
            '_id': OrderItem.id,
            'service': Service.name,
            'supplier': Supplier.name,
            'status': OrderItem.status,
            'price': OrderItem.price,
            'final_price': OrderItem.final_price,
            'discount': OrderItem.discount,
            'currency': Currency.iso_code,
        }
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = (
            self.query
            .join(OrderItem, Resource.order_item)
            .join(
                Service,
                OrderItem.service
            )
            .join(
                Supplier,
                OrderItem.supplier
            )
            .join(
                Currency,
                OrderItem.currency
            )
        )
        super(OrdersItemsQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(OrderItem.id.in_(id))
