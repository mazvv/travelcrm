# -*-coding: utf-8 -*-

import colander

from . import ResourceSchema


class AppointmentSchema(ResourceSchema):
    uuid = colander.SchemaNode(
        colander.String(),
        missing=None
    )
    appointment_date = colander.SchemaNode(
        colander.String(),
    )


class AppointmentRowSchema(colander.Schema):
    uuid = colander.SchemaNode(
        colander.String(),
        missing=None
    )
    appointment_header_id = colander.SchemaNode(
        colander.String(),
        missing=None
    )
    employee_id = colander.SchemaNode(
        colander.Integer(),
    )
    position_id = colander.SchemaNode(
        colander.Integer(),
    )
