# -*-coding: utf-8 -*-

import colander


class LoginForm(colander.MappingSchema):
    username = colander.SchemaNode(
        colander.String(),
        missing=u''
    )
    password = colander.SchemaNode(
        colander.String(),
        missing=u'',
    )
