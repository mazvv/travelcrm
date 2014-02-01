# -*-coding: utf-8 -*-

import colander

from . import ResourceSchema


class CompanySchema(ResourceSchema):
    name = colander.SchemaNode(
        colander.String(),
    )
