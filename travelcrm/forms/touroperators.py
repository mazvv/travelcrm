# -*-coding: utf-8 -*-

import colander

from . import ResourceSchema


class TouroperatorSchema(ResourceSchema):
    tid = colander.SchemaNode(
        colander.Integer(),
    )
    name = colander.SchemaNode(
        colander.String(),
    )
