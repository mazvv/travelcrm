# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder

from ...models.resource import Resource
from ...models.offer import Offer
from ...models.service import Service
from ...models.currency import Currency


class OfferQueryBuilder(ResourcesQueryBuilder):


    def __init__(self, context):
        super(OfferQueryBuilder, self).__init__(context)
        self._fields = {
            'id': Offer.id,
            '_id': Offer.id,
            'service': Service.name,
            'price': Offer.price,
            'currency': Currency.iso_code,
        }
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = (
            self.query
            .join(Offer, Resource.offer)
            .join(
                Service,
                Offer.service
            )
            .join(
                Currency,
                Offer.currency
            )
        )
        super(OfferQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Offer.id.in_(id))
