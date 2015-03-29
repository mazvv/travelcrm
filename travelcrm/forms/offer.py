# -*-coding: utf-8 -*-

import colander

from . import ResourceSchema


class OfferItemSchema(ResourceSchema):
    service_id = colander.SchemaNode(
        colander.Integer(),
    )
    currency_id = colander.SchemaNode(
        colander.Integer(),
    )
    price = colander.SchemaNode(
        colander.Money(),
    )
    descr = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=1024)
    )