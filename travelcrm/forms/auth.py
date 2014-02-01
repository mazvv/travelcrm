# -*-coding: utf-8 -*-

import colander


class LoginSchema(colander.Schema):
    username = colander.SchemaNode(
        colander.String(),
        missing=u''
    )
    password = colander.SchemaNode(
        colander.String(),
        missing=u'',
    )


class ForgotSchema(colander.Schema):
    email = colander.SchemaNode(
        colander.String(),
        validator=colander.Email(),
    )
