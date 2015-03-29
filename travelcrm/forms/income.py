# -*-coding: utf-8 -*-

import colander

from . import ResourceSchema, Date, ResourceSearchSchema

class IncomeSchema(ResourceSchema):
    invoice_id = colander.SchemaNode(
        colander.Integer(),
    )
    date = colander.SchemaNode(
        Date(),
    )
    sum = colander.SchemaNode(
        colander.Money(),
        validator=colander.Range(min=0)
    )


class IncomeSearchSchema(ResourceSearchSchema):
    invoice_id = colander.SchemaNode(
        colander.Integer(),
        missing=None
    )
    account_id = colander.SchemaNode(
        colander.Integer(),
        missing=None
    )
    currency_id = colander.SchemaNode(
        colander.Integer(),
        missing=None
    )
    payment_from = colander.SchemaNode(
        Date(),
        missing=None
    )
    payment_to = colander.SchemaNode(
        Date(),
        missing=None
    )
    sum_from = colander.SchemaNode(
        colander.Decimal(),
        missing=None
    )
    sum_to = colander.SchemaNode(
        colander.Decimal(),
        missing=None
    )
