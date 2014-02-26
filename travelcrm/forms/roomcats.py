# -*-coding: utf-8 -*-

import colander

from . import ResourceSchema


class RoomcatSchema(ResourceSchema):
    name = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=32),
    )
