# -*-coding: utf-8 -*-

import colander


class SalesDynamicsSchema(colander.Schema):
    days = colander.SchemaNode(
        colander.Integer(),
        missing=7,
    )


class SettingsSchema(colander.Schema):
    column_index = colander.SchemaNode(
        colander.Integer()
    )
