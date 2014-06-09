# -*-coding: utf-8 -*-

import colander

from . import ResourceSchema, Date


class IncomeSchema(ResourceSchema):
    invoice_id = colander.SchemaNode(
        colander.Integer(),
    )
    sum = colander.SchemaNode(
        colander.Money(),
    )
    date = colander.SchemaNode(
        Date(),
    )


class IncomeCurrencySchema(ResourceSchema):
    invoice_id = colander.SchemaNode(
        colander.Integer(),
    )
