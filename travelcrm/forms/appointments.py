# -*-coding: utf-8 -*-

import colander

from . import (
    ResourceSchema,
    Date
)


class AppointmentSchema(ResourceSchema):
    date = colander.SchemaNode(
        Date(),
    )
    employee_id = colander.SchemaNode(
        colander.Integer(),
    )
    position_id = colander.SchemaNode(
        colander.Integer(),
    )
    salary = colander.SchemaNode(
        colander.Money(),
    )
    currency_id = colander.SchemaNode(
        colander.Integer(),
    )
