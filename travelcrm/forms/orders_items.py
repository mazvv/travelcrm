# -*-coding: utf-8 -*-

import colander

from . import (
    Date,
    SelectInteger,
    ResourceSchema,
    BaseForm,
    BaseSearchForm,
)
from ..resources.orders_items import OrdersItemsResource
from ..models.order_item import OrderItem
from ..models.currency import Currency
from ..models.supplier import Supplier
from ..models.service import Service
from ..models.person import Person
from ..lib.qb.orders_items import OrdersItemsQueryBuilder
from ..lib.utils.security_utils import get_auth_employee


class OrderItemSchema(ResourceSchema):
    service_id = colander.SchemaNode(
        SelectInteger(Service),
    )
    currency_id = colander.SchemaNode(
        SelectInteger(Currency),
    )
    supplier_id = colander.SchemaNode(
        SelectInteger(Supplier),
    )
    price = colander.SchemaNode(
        colander.Money()
    )
    discount_sum = colander.SchemaNode(
        colander.Money(),
        missing=0,
    )
    discount_percent = colander.SchemaNode(
        colander.Money(),
        missing=0,
    )
    person_id = colander.SchemaNode(
        colander.Set(),
    )
    status = colander.SchemaNode(
        colander.String(),
    )
    status_date = colander.SchemaNode(
        Date(),
        missing=None
    )
    status_info = colander.SchemaNode(
        colander.String(),
        missing=None,
        validator=colander.Length(max=128)
    )

    def deserialize(self, cstruct):
        if (
            'person_id' in cstruct
            and not isinstance(cstruct.get('person_id'), list)
        ):
            val = cstruct['person_id']
            cstruct['person_id'] = list()
            cstruct['person_id'].append(val)

        return super(OrderItemSchema, self).deserialize(cstruct)


class OrderItemForm(BaseForm):
    _schema = OrderItemSchema

    def submit(self, order_item=None):
        if not order_item:
            order_item = OrderItem(
                resource=OrdersItemsResource.create_resource(
                    get_auth_employee(self.request)
                )
            )
        else:
            order_item.persons = []

        order_item.service_id = self._controls.get('service_id')
        order_item.currency_id = self._controls.get('currency_id')
        order_item.supplier_id = self._controls.get('supplier_id')
        order_item.price = self._controls.get('price')
        order_item.discount_sum = self._controls.get('discount_sum')
        order_item.discount_percent = self._controls.get('discount_percent')
        order_item.status = self._controls.get('status')
        order_item.status_date = self._controls.get('status_date')
        order_item.status_info = self._controls.get('status_info')
        for id in self._controls.get('person_id'):
            person = Person.get(id)
            order_item.persons.append(person)
        return order_item


class OrderItemSearchForm(BaseSearchForm):
    _qb = OrdersItemsQueryBuilder
