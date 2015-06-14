# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder

from ...models.resource import Resource
from ...models.lead_item import LeadItem
from ...models.service import Service
from ...models.currency import Currency


class LeadsItemsQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(LeadsItemsQueryBuilder, self).__init__(context)
        self._fields = {
            'id': LeadItem.id,
            '_id': LeadItem.id,
            'service': Service.name,
            'price_from': LeadItem.price_from,
            'price_to': LeadItem.price_to,
            'currency': Currency.iso_code,
        }
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = (
            self.query
            .join(LeadItem, Resource.lead_item)
            .join(
                Service,
                LeadItem.service
            )
            .outerjoin(
                Currency,
                LeadItem.currency
            )
        )
        super(LeadsItemsQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(LeadItem.id.in_(id))
