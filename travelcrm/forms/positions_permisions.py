# -*-coding: utf-8 -*-

import colander


class PositionPermisionSchema(colander.Schema):
    companies_positions_id = colander.SchemaNode(
        colander.Integer(),
    )
    resources_types_id = colander.SchemaNode(
        colander.Integer(),
    )
    scope_type = colander.SchemaNode(
        colander.String(),
    )
    companies_struct_id = colander.SchemaNode(
        colander.Integer(),
        missing=None
    )
    permisions = colander.Set()
