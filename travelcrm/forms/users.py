# -*-coding: utf-8 -*-

import colander

from . import ResourceSchema


class UserSchemaAdd(ResourceSchema):
    username = colander.SchemaNode(
        colander.String(),
    )
    password = colander.SchemaNode(
        colander.String(),
    )
    employees_id = colander.SchemaNode(
        colander.Integer(),
    )


class UserSchemaEdit(UserSchemaAdd):
    password = colander.SchemaNode(
        colander.String(),
        missing=""
    )
