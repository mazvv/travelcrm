# -*-coding: utf-8 -*-

import colander

from . import ResourceSchema


class AppointmentSchema(ResourceSchema):
    appointment_date = colander.SchemaNode(
        colander.String(),
    )


class AppointmentRowSchema(colander.Schema):
    employees_id = colander.SchemaNode(
        colander.Integer(),
    )
    companies_positions_id = colander.SchemaNode(
        colander.Integer(),
    )
