# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder

from ...models.resource import Resource
from ...models.wish import Wish
from ...models.service import Service
from ...models.currency import Currency


class WishQueryBuilder(ResourcesQueryBuilder):


    def __init__(self, context):
        super(WishQueryBuilder, self).__init__(context)
        self._fields = {
            'id': Wish.id,
            '_id': Wish.id,
            'service': Service.name,
            'price_from': Wish.price_from,
            'price_to': Wish.price_to,
            'currency': Currency.iso_code,
        }
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = (
            self.query
            .join(Wish, Resource.wish)
            .join(
                Service,
                Wish.service
            )
            .outerjoin(
                Currency,
                Wish.currency
            )
        )
        super(WishQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Wish.id.in_(id))
