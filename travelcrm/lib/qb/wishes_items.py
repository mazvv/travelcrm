# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder

from ...models.resource import Resource
from ...models.wish_item import WishItem
from ...models.service import Service
from ...models.currency import Currency


class WishesItemsQueryBuilder(ResourcesQueryBuilder):


    def __init__(self, context):
        super(WishesItemsQueryBuilder, self).__init__(context)
        self._fields = {
            'id': WishItem.id,
            '_id': WishItem.id,
            'service': Service.name,
            'price_from': WishItem.price_from,
            'price_to': WishItem.price_to,
            'currency': Currency.iso_code,
        }
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = (
            self.query
            .join(WishItem, Resource.wish_item)
            .join(
                Service,
                WishItem.service
            )
            .outerjoin(
                Currency,
                WishItem.currency
            )
        )
        super(WishesItemsQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(WishItem.id.in_(id))
