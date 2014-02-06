# -*-coding: utf-8 -*-

import colander

from . import ResourceSchema


class CurrencySchema(ResourceSchema):
    iso_code = colander.SchemaNode(
        colander.String(),
    )
