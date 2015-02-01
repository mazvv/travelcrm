# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder

from ...models.resource import Resource
from ...models.service_item import ServiceItem
from ...models.service import Service
from ...models.currency import Currency
from ...models.touroperator import Touroperator
from ...models.person import Person


class ServicesItemsQueryBuilder(ResourcesQueryBuilder):


    def __init__(self, context):
        super(ServicesItemsQueryBuilder, self).__init__(context)
        self._fields = {
            'id': ServiceItem.id,
            '_id': ServiceItem.id,
            'service': Service.name,
            'touroperator': Touroperator.name,
            'price': ServiceItem.price,
            'person': Person.name,
            'currency': Currency.iso_code,
        }
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = (
            self.query
            .join(ServiceItem, Resource.service_item)
            .join(
                Service,
                ServiceItem.service
            )
            .join(
                Touroperator,
                ServiceItem.touroperator
            )
            .join(
                Currency,
                ServiceItem.currency
            )
            .join(
                Person,
                ServiceItem.person
            )
        )
        super(ServicesItemsQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(ServiceItem.id.in_(id))
