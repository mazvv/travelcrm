# -*-coding: utf-8 -*-

import colander

from . import ResourceSearchSchema, Date


class DebtSearchSchema(ResourceSearchSchema):
    currency_id = colander.SchemaNode(
        colander.Integer(),
        missing=None,
    )
    date_from = colander.SchemaNode(
        Date(),
        missing=None,
    )
    date_to = colander.SchemaNode(
        Date(),
        missing=None,
    )
