# -*-coding: utf-8 -*-

import colander

from . import ResourceSchema


class HotelSchema(ResourceSchema):
    name = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=32),
    )
    hotelcat_id = colander.SchemaNode(
        colander.Integer(),
    )
    location_id = colander.SchemaNode(
        colander.Integer(),
        missing=None
    )
