# -*-coding: utf-8 -*-

import colander

from . import ResourceSchema


class AppointmentSchema(ResourceSchema):
    tid = colander.SchemaNode(
        colander.Integer(),
    )
    appointment_date = colander.SchemaNode(
        colander.String(),
    )


class TAppointmentRowSchema(colander.Schema):
    employee_id = colander.SchemaNode(
        colander.Integer(),
    )
    position_id = colander.SchemaNode(
        colander.Integer(),
    )
    main_id = colander.SchemaNode(
        colander.Integer(),
        missing=None,
    )
    tid = colander.SchemaNode(
        colander.Integer(),
    )
