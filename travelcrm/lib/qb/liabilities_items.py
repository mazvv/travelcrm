# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder

from ...models.resource import Resource
from ...models.liability_item import LiabilityItem
from ...models.service import Service
from ...models.currency import Currency
from ...models.touroperator import Touroperator


class LiabilitiesItemsQueryBuilder(ResourcesQueryBuilder):

    _fields = {
        'id': LiabilityItem.id,
        '_id': LiabilityItem.id,
        'service': Service.name,
        'touroperator': Touroperator.name,
        'price': LiabilityItem.price,
        'currency': Currency.iso_code,
    }

    def __init__(self, context):
        super(LiabilitiesItemsQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = (
            self.query
            .join(LiabilityItem, Resource.liability_item)
            .join(
                Service,
                LiabilityItem.service
            )
            .join(
                Touroperator,
                LiabilityItem.touroperator
            )
            .join(
                Currency,
                LiabilityItem.currency
            )
        )
        self.query = self.query.add_columns(*fields)

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(LiabilityItem.id.in_(id))
