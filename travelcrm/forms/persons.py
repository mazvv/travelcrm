# -*-coding: utf-8 -*-

import colander

from . import ResourceSchema


class PersonSchema(ResourceSchema):
    first_name = colander.SchemaNode(
        colander.String(),
    )
    last_name = colander.SchemaNode(
        colander.String(),
    )
    second_name = colander.SchemaNode(
        colander.String(),
        missing=u""
    )
