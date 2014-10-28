# -*-coding: utf-8 -*-

import colander

from . import ResourceSchema


class CalculationSchema(ResourceSchema):
    currency_id = colander.SchemaNode(
        colander.Integer(),
    )
    price = colander.SchemaNode(
        colander.Money()
    )
