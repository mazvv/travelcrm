# -*-coding: utf-8 -*-

import colander

from . import ResourceForm


class AddForm(ResourceForm):
    _companies_rid = colander.SchemaNode(
        colander.Integer()
    )
    _companies_structures_rid = colander.SchemaNode(
        colander.Integer(),
        missing=None
    )
    name = colander.SchemaNode(
        colander.String(),
    )


class EditForm(AddForm):
    pass
