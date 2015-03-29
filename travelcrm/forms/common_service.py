# -*-coding: utf-8 -*-

import colander

from . import ResourceSchema

from ..resources.order_item import OrderItemResource
from ..models.order_item import OrderItem


class _CommonServiceSchema(ResourceSchema):
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


class CommonServiceForm():
    _schema = _CommonServiceSchema
    _controls = None
    _errors = None

    def __init__(self, request):
        self.request = request

    def validate(self):
        try:
            self._controls = self._schema.deserialize(self.request.params)
            return True
        except colander.Invalid as e:
            self._errors = e.asdict()
            return False

    @property
    def errors(self):
        return self._errors

    def populate(self):
        order_item_context = ROrderItem(self.request)
        order_item = MOrderItem(
            service_id=self._controls.get('service_id'),
            touroperator_id=self._controls.get('touroperator_id'),
            currency_id=self._controls.get('currency_id'),
            price=self._controls.get('price'),
            resource=order_item_context.create_resource()
        )
        
        DBSession.add(service_item)
        DBSession.flush()
