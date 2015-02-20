# -*-coding: utf-8 -*-

import colander

from . import (
    Date,
    ResourceSchema,
    ResourceSearchSchema,
)
from ..models.person import Person
from ..lib.utils.common_utils import cast_int
from ..lib.utils.common_utils import translate as _


class LeadSchema(ResourceSchema):
    lead_date = colander.SchemaNode(
        Date()
    )
    customer_id = colander.SchemaNode(
        colander.Integer(),
    )
    advsource_id = colander.SchemaNode(
        colander.Integer(),
    )


class LeadSearchSchema(ResourceSearchSchema):
    pass
