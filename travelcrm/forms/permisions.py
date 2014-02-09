# -*-coding: utf-8 -*-

import colander


class PermisionSchema(colander.Schema):
    position_id = colander.SchemaNode(
        colander.Integer(),
    )
    resource_type_id = colander.SchemaNode(
        colander.Integer(),
    )
    scope_type = colander.SchemaNode(
        colander.String(),
    )
    structure_id = colander.SchemaNode(
        colander.Integer(),
        missing=None
    )
    permisions = colander.Set()
