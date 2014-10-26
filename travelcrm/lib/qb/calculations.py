# -*coding: utf-8-*-

from collections import Iterable

from sqlalchemy.orm import aliased

from . import ResourcesQueryBuilder

from ...models.resource import Resource
from ...models.service_item import ServiceItem
from ...models.calculation import Calculation
from ...models.service import Service
from ...models.currency import Currency
from ...models.touroperator import Touroperator


ServiceItemCurrency = aliased(Currency)
CalculationCurrency = aliased(Currency)


class CalculationsQueryBuilder(ResourcesQueryBuilder):

    _fields = {
        'id': Calculation.id,
        '_id': Calculation.id,
        'service': Service.name,
        'touroperator': Touroperator.name,
        'price': ServiceItem.price,
        'base_price': ServiceItem.base_price,
        'currency': ServiceItemCurrency.iso_code,
        'supplier_price': Calculation.price,
        'supplier_currency': CalculationCurrency.iso_code,
        'supplier_base_price': Calculation.base_price,
    }

    def __init__(self, context):
        super(CalculationsQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = (
            self.query
            .join(Calculation, Resource.calculation)
            .join(ServiceItem, Calculation.service_item)
            .join(Service, ServiceItem.service)
            .join(Touroperator, ServiceItem.touroperator)
            .join(ServiceItemCurrency, ServiceItem.currency)
            .join(CalculationCurrency, Calculation.currency)
        )
        self.query = self.query.add_columns(*fields)

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Calculation.id.in_(id))
