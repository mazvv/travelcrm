# -*-coding: utf-8 -*-

import colander

from . import (
    ResourceSchema,
    Date
)


class PersonSchema(ResourceSchema):
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
    gender = colander.SchemaNode(
        colander.String(),
        validators=colander.OneOf([u'male', u'female']),
        missing=None,
    )
    birthday = colander.SchemaNode(
        Date(),
        missing=None,
    )
