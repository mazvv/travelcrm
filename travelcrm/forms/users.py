# -*-coding: utf-8 -*-

import colander

from . import ResourceSchema


class UserAddSchema(ResourceSchema):
    username = colander.SchemaNode(
        colander.String(),
    )
    password = colander.SchemaNode(
        colander.String(),
    )
    employee_id = colander.SchemaNode(
        colander.Integer(),
    )


class UserEditSchema(UserAddSchema):
    password = colander.SchemaNode(
        colander.String(),
        missing=""
    )
