# -*-coding: utf-8 -*-

import colander

from . import ResourceForm


class AddForm(ResourceForm):
    name = colander.SchemaNode(
        colander.String(),
    )


class EditForm(AddForm):
    pass
