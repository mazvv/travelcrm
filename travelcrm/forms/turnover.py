# -*-coding: utf-8 -*-

import colander

from . import ResourceSearchSchema, Date


class TurnoverSearchSchema(ResourceSearchSchema):
    report_by = colander.SchemaNode(
        colander.String(),
        missing='account',
    )
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
