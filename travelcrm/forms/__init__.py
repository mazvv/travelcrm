# -*-coding: utf-8-*-

import colander


class ResourceForm(colander.MappingSchema):
    status = colander.SchemaNode(
        colander.Integer(),
    )
