# -*-coding: utf-8 -*-

import colander

from . import ResourceSchema


class TouroperatorSchema(ResourceSchema):
    name = colander.SchemaNode(
        colander.String(),
    )
