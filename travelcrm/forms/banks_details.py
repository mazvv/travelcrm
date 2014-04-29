# -*-coding: utf-8 -*-

import colander

from . import ResourceSchema


class BankDetailSchema(ResourceSchema):
    currency_id = colander.SchemaNode(
        colander.Integer(),
    )
    bank_id = colander.SchemaNode(
        colander.Integer(),
    )
    beneficiary = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=255)
    )
    account = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=32)
    )
    swift_code = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=32)
    )
