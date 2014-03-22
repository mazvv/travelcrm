# -*-coding: utf-8 -*-

import colander

from . import ResourceSchema


class CurrencySchema(ResourceSchema):
    iso_code = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(min=3, max=3)
    )
