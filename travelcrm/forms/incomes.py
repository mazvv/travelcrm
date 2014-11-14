# -*-coding: utf-8 -*-

import colander

from . import ResourceSchema, Date

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


class SettingsSchema(colander.Schema):
    account_item_id = colander.SchemaNode(
        colander.Integer()
    )
