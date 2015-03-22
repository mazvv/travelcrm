# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder

from ...models.resource import Resource
from ...models.offer_item import OfferItem
from ...models.service import Service
from ...models.currency import Currency


class OffersItemsQueryBuilder(ResourcesQueryBuilder):


    def __init__(self, context):
        super(OffersItemsQueryBuilder, self).__init__(context)
        self._fields = {
            'id': OfferItem.id,
            '_id': OfferItem.id,
            'service': Service.name,
            'price': OfferItem.price,
            'currency': Currency.iso_code,
        }
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = (
            self.query
            .join(OfferItem, Resource.offer_item)
            .join(
                Service,
                OfferItem.service
            )
            .join(
                Currency,
                OfferItem.currency
            )
        )
        super(OffersItemsQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(OfferItem.id.in_(id))
