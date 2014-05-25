# -*-coding: utf-8 -*-

import colander

from . import ResourceSchema, Date


class InvoiceAddSchema(ResourceSchema):
    invoice_resource_id = colander.SchemaNode(
        colander.Integer(),
    )
    date = colander.SchemaNode(
        Date(),
    )
    bank_detail_id = colander.SchemaNode(
        colander.Integer()
    )


class InvoiceEditSchema(ResourceSchema):
    invoice_resource_id = colander.SchemaNode(
        colander.Integer(),
        missing=None
    )
