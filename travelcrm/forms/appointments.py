# -*-coding: utf-8 -*-

import colander

from . import (
    ResourceSchema,
    Date
)
from ..lib.bl.employees import get_employee_last_appointment
from ..lib.utils.common_utils import translate as _


@colander.deferred
def date_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        employee_id = request.params.get('employee_id')
        if employee_id:
            appointment = get_employee_last_appointment(employee_id)
            if appointment and appointment.date >= value:
                raise colander.Invalid(
                    node,
                    _(u'Appointment with bigger date already exists')
                )
    return colander.All(validator,)


class AppointmentSchema(ResourceSchema):
    date = colander.SchemaNode(
        Date(),
        validator=date_validator
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
