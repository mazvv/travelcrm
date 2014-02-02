# -*-coding: utf-8 -*-

import colander

from . import ResourceSchema


class EmployeeAppointmentSchema(ResourceSchema):
    appointment_date = colander.SchemaNode(
        colander.String(),
    )


class EmployeeAppointmentRowSchema(colander.Schema):
    employees_id = colander.SchemaNode(
        colander.Integer(),
    )
    companies_positions_id = colander.SchemaNode(
        colander.Integer(),
    )
