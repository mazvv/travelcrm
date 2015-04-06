# -*-coding: utf-8 -*-

import colander

from . import (
    ResourceSchema,
    BaseForm,
    BaseSearchForm,
)
from ..resources.order_item import OrderItemResource
from ..models.order_item import OrderItem
from ..models.person import Person
from ..lib.qb.order_item import OrderItemQueryBuilder


class _OrderItemSchema(ResourceSchema):
    service_id = colander.SchemaNode(
        colander.Integer(),
    )
    currency_id = colander.SchemaNode(
        colander.Integer(),
    )
    touroperator_id = colander.SchemaNode(
        colander.Integer(),
    )
    price = colander.SchemaNode(
        colander.Money()
    )
    person_id = colander.SchemaNode(
        colander.Set(),
    )

    def deserialize(self, cstruct):
        if (
            'person_id' in cstruct
            and not isinstance(cstruct.get('person_id'), list)
        ):
            val = cstruct['person_id']
            cstruct['person_id'] = list()
            cstruct['person_id'].append(val)

        return super(_OrderItemSchema, self).deserialize(cstruct)


class OrderItemForm(BaseForm):
    _schema = _OrderItemSchema

    def submit(self, order_item=None):
        context = OrderItemResource(self.request)
        if not order_item:
            order_item = OrderItem(
                resource=context.create_resource()
            )
        order_item.service_id = self._controls.get('service_id')
        order_item.currency_id = self._controls.get('currency_id')
        order_item.touroperator_id = self._controls.get('touroperator_id')
        order_item.price = self._controls.get('price')
        for id in self._controls.get('person_id'):
            person = Person.get(id)
            order_item.persons.append(person)
        return order_item


class OrderItemSearchForm(BaseSearchForm):
    _qb = OrderItemQueryBuilder
