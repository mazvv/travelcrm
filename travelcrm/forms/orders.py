# -*-coding: utf-8 -*-

import colander

from . import (
    Date,
    SelectInteger,
    ResourceSchema,
    ResourceSearchSchema,
    BaseForm,
    BaseSearchForm,
    BaseAssignForm,
)
from ..resources.orders import OrdersResource
from ..models.order import Order
from ..models.order_item import OrderItem
from ..models.lead import Lead
from ..models.person import Person
from ..models.advsource import Advsource
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.orders import OrdersQueryBuilder
from ..lib.bl.currencies_rates import currency_base_exchange
from ..lib.utils.security_utils import get_auth_employee
from ..lib.utils.resources_utils import get_resource_type_by_resource


class _OrderSchema(ResourceSchema):
    deal_date = colander.SchemaNode(
        Date()
    )
    lead_id = colander.SchemaNode(
        SelectInteger(Lead),
        missing=None,
    )
    customer_id = colander.SchemaNode(
        SelectInteger(Person),
    )
    advsource_id = colander.SchemaNode(
        SelectInteger(Advsource),
    )
    order_item_id = colander.SchemaNode(
        colander.Set(),
    )
    status = colander.SchemaNode(
        colander.String(),
    )
    descr = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=255),
        missing=None
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
        if not order:
            order = Order(
                resource=OrdersResource.create_resource(
                    get_auth_employee(self.request)
                )
            )
        else:
            order.orders_items = []
            order.resource.notes = []
            order.resource.tasks = []

        order.deal_date = self._controls.get('deal_date')
        order.lead_id = self._controls.get('lead_id')
        order.advsource_id = self._controls.get('advsource_id')
        order.customer_id = self._controls.get('customer_id')
        order.status = self._controls.get('status')
        order.descr = self._controls.get('descr')

        for id in self._controls.get('order_item_id'):
            order_item = OrderItem.get(id)
            order_item.base_price = currency_base_exchange(
                order_item.final_price, 
                order_item.currency_id, 
                order_item.supplier_id, 
                order.deal_date
            )
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
    _qb = OrdersQueryBuilder


class OrderAssignForm(BaseAssignForm):
    def submit(self, ids):
        for id in ids:
            order = Order.get(id)
            order.resource.maintainer_id = self._controls.get(
                'maintainer_id'
            )

class _OrderSettingsSchema(colander.Schema):
    html_template = colander.SchemaNode(
        colander.String(),
    )


class OrderSettingsForm(BaseForm):
    _schema = _OrderSettingsSchema

    def submit(self):
        context = OrdersResource(self.request)
        rt = get_resource_type_by_resource(context)
        rt.settings = {
            'html_template': self._controls.get('html_template'),
        }
