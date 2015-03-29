# -*-coding: utf-8 -*-

import colander

from . import ResourceSchema


class AddressSchema(ResourceSchema):
    location_id = colander.SchemaNode(
        colander.Integer(),
    )
    zip_code = colander.SchemaNode(
        colander.String()
    )
    address = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(min=2, max=255)
    )
