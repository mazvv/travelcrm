# -*-coding: utf-8-*-

import colander


class ResourceSchema(colander.Schema):
    status = colander.SchemaNode(
        colander.Integer(),
    )
