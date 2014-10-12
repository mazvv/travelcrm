# -*-coding: utf-8 -*-

import colander

from . import ResourceSchema


class NoteSchema(ResourceSchema):
    title = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(min=2, max=255)
    )
    descr = colander.SchemaNode(
        colander.String(),
        missing=None,
    )
