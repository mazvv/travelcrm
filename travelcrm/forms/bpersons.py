# -*-coding: utf-8 -*-

import colander

from . import ResourceSchema


class BPersonSchema(ResourceSchema):
    tid = colander.SchemaNode(
        colander.Integer(),
    )
    first_name = colander.SchemaNode(
        colander.String(),
    )
    last_name = colander.SchemaNode(
        colander.String(),
        missing=u""
    )
    second_name = colander.SchemaNode(
        colander.String(),
        missing=u""
    )
    position_name = colander.SchemaNode(
        colander.String(),
    )
