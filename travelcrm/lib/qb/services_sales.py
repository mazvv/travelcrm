# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder

from ...models.resource import Resource
from ...models.service_sale import ServiceSale
from ...models.person import Person


class ServicesSalesQueryBuilder(ResourcesQueryBuilder):

    _fields = {
        'id': ServiceSale.id,
        '_id': ServiceSale.id,
        'deal_date': ServiceSale.deal_date,
        'customer': Person.name,
    }

    def __init__(self, context):
        super(ServicesSalesQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = (
            self.query
            .join(ServiceSale, Resource.service_sale)
            .join(Person, ServiceSale.customer)
        )
        self.query = self.query.add_columns(*fields)

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(ServiceSale.id.in_(id))
