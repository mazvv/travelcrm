# -*-coding: utf-8 -*-

import colander

from . import Date


class LicenceSchema(colander.Schema):
    licence_num = colander.SchemaNode(
        colander.String(),
        validators=colander.Length(min=2, max=32)
    )
    date_from = colander.SchemaNode(
        Date(),
    )
    date_to = colander.SchemaNode(
        Date(),
    )
