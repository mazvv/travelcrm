# -*-coding: utf-8 -*-

import colander


class SettingsSchema(colander.Schema):
    column_index = colander.SchemaNode(
        colander.Integer()
    )
