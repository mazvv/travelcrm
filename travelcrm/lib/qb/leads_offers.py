# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder

from ...models.resource import Resource
from ...models.lead_offer import LeadOffer
from ...models.service import Service
from ...models.supplier import Supplier
from ...models.currency import Currency


class LeadsOffersQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(LeadsOffersQueryBuilder, self).__init__(context)
        self._fields = {
            'id': LeadOffer.id,
            '_id': LeadOffer.id,
            'service': Service.name,
            'supplier': Supplier.name,
            'status': LeadOffer.status,
            'price': LeadOffer.price,
            'currency': Currency.iso_code,
        }
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = (
            self.query
            .join(LeadOffer, Resource.lead_offer)
            .join(Service, LeadOffer.service)
            .join(Currency, LeadOffer.currency)
            .join(Supplier, LeadOffer.supplier)
        )
        super(LeadsOffersQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(LeadOffer.id.in_(id))
