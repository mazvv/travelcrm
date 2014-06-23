# -*coding: utf-8-*-
from collections import Iterable

from sqlalchemy import func, literal

from . import ResourcesQueryBuilder

from ...models import DBSession
from ...models.resource import Resource
from ...models.service_sale import ServiceSale
from ...models.service_item import ServiceItem
from ...models.person import Person
from ...models.invoice import Invoice

from ...lib.utils.common_utils import get_base_currency


class ServicesSalesQueryBuilder(ResourcesQueryBuilder):

    _subq_services_price = (
        DBSession.query(
            ServiceSale.id,
            func.sum(ServiceItem.base_price)
            .label('base_price')
        )
        .join(ServiceItem, ServiceSale.services_items)
        .group_by(ServiceSale.id)
        .subquery()
    )

    _fields = {
        'id': ServiceSale.id,
        '_id': ServiceSale.id,
        'deal_date': ServiceSale.deal_date,
        'customer': Person.name,
        'base_price': _subq_services_price.c.base_price,
        'invoice_id': Invoice.id,
    }

    def __init__(self, context):
        super(ServicesSalesQueryBuilder, self).__init__(context)
        self._fields['base_currency'] = literal(get_base_currency())
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = (
            self.query
            .join(ServiceSale, Resource.service_sale)
            .join(Person, ServiceSale.customer)
            .join(
                self._subq_services_price,
                self._subq_services_price.c.id == ServiceSale.id
            )
            .outerjoin(Invoice, ServiceSale.invoice)
        )
        self.query = self.query.add_columns(*fields)

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(ServiceSale.id.in_(id))
