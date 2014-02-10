# -*-coding: utf-8 -*-

import colander

from . import ResourceSchema


class CountrySchema(ResourceSchema):
    iso_code = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=2),
    )
    name = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=32),
    )
