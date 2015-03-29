# -*-coding: utf-8 -*-

import colander

from . import Date, ResourceSchema


class CommissionSchema(ResourceSchema):
    date_from = colander.SchemaNode(
        Date(),
    )
    service_id = colander.SchemaNode(
        colander.Integer()
    )
    percentage = colander.SchemaNode(
        colander.Decimal(),
        validator=colander.Range(min=0, max=100)
    )
    price = colander.SchemaNode(
        colander.Money(),
    )
    currency_id = colander.SchemaNode(
        colander.Integer(),
    )
