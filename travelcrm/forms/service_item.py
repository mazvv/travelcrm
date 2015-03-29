# -*-coding: utf-8 -*-

import colander

from . import ResourceSchema


class ServiceItemSchema(ResourceSchema):
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
