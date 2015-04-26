# -*-coding: utf-8 -*-

import colander

from . import (
    Date,
    ResourceSchema,
    ResourceSearchSchema,
    BaseForm,
    BaseSearchForm,
)
from ..resources.order import OrderResource
from ..models.order import Order
from ..models.order_item import OrderItem
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.order import OrderQueryBuilder


class _OrderSchema(ResourceSchema):
    deal_date = colander.SchemaNode(
        Date()
    )
    customer_id = colander.SchemaNode(
        colander.Integer(),
    )
    advsource_id = colander.SchemaNode(
        colander.Integer(),
    )
    order_item_id = colander.SchemaNode(
        colander.Set(),
    )

    def deserialize(self, cstruct):
        if (
            'order_item_id' in cstruct
            and not isinstance(cstruct.get('order_item_id'), list)
        ):
            val = cstruct['order_item_id']
            cstruct['order_item_id'] = list()
            cstruct['order_item_id'].append(val)

        return super(_OrderSchema, self).deserialize(cstruct)


class _OrderSearchSchema(ResourceSearchSchema):
    person_id = colander.SchemaNode(
        colander.Integer(),
        missing=None,
    )
    service_id = colander.SchemaNode(
        colander.Integer(),
        missing=None,
    )
    price_from = colander.SchemaNode(
        colander.Money(),
        missing=None,
    )
    price_to = colander.SchemaNode(
        colander.Money(),
        missing=None,
    )
    sale_from = colander.SchemaNode(
        Date(),
        missing=None,
    )
    sale_to = colander.SchemaNode(
        Date(),
        missing=None,
    )


class OrderForm(BaseForm):
    _schema = _OrderSchema

    def submit(self, order=None):
        context = OrderResource(self.request)
        if not order:
            order = Order(
                resource=context.create_resource()
            )
        else:
            order.orders_items = []
            order.resource.notes = []
            order.resource.tasks = []
        order.deal_date = self._controls.get('deal_date'),
        order.advsource_id = self._controls.get('advsource_id'),
        order.customer_id = self._controls.get('customer_id'),
        for id in self._controls.get('order_item_id'):
            order_item = OrderItem.get(id)
            order.orders_items.append(order_item)
        for id in self._controls.get('note_id'):
            note = Note.get(id)
            order.resource.notes.append(note)
        for id in self._controls.get('task_id'):
            task = Task.get(id)
            order.resource.tasks.append(task)
        return order


class OrderSearchForm(BaseSearchForm):
    _schema = _OrderSearchSchema
    _qb = OrderQueryBuilder
