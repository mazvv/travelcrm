# -*-coding: utf-8 -*-

import colander

from . import ResourceSchema


class OrderItemSchema(ResourceSchema):
    service_id = colander.SchemaNode(
        colander.Integer(),
    )
    currency_id = colander.SchemaNode(
        colander.Integer(),
    )
    touroperator_id = colander.SchemaNode(
        colander.Integer(),
    )
    person_id = colander.SchemaNode(
        colander.Integer(),
    )
    price = colander.SchemaNode(
        colander.Money()
    )


class OrderItemServiceSchema(colander.Schema):
    service_id = colander.SchemaNode(
        colander.Integer(),
    )
