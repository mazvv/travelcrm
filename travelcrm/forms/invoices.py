# -*-coding: utf-8 -*-

import colander

from . import ResourceSchema, Date


class InvoiceAddSchema(ResourceSchema):
    resource_id = colander.SchemaNode(
        colander.Integer(),
    )
    date = colander.SchemaNode(
        Date(),
    )
    account_id = colander.SchemaNode(
        colander.Integer()
    )


class InvoiceEditSchema(ResourceSchema):
    date = colander.SchemaNode(
        Date(),
    )
    account_id = colander.SchemaNode(
        colander.Integer()
    )


class InvoiceSumSchema(ResourceSchema):
    resource_id = colander.SchemaNode(
        colander.Integer(),
    )
    date = colander.SchemaNode(
        Date(),
    )
    account_id = colander.SchemaNode(
        colander.Integer()
    )
