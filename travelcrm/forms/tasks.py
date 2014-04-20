# -*-coding: utf-8 -*-

import colander

from . import (
    ResourceSchema,
    Date,
    Time,
)
from ..lib.bl.tasks import PRIORITIES


@colander.deferred
def reminder_validator(node, kw):
    request = kw.get('request')
    _ = request.translate

    def validator(node, value):
        if (
            value and not request.params.get('reminder_time')
            or not value and request.params.get('reminder_time')
        ):

            raise colander.Invalid(
                node,
                _(u"Set date and time or leave empty both")
            )
    return colander.All(validator,)


class TaskSchema(ResourceSchema):
    employee_id = colander.SchemaNode(
        colander.Integer(),
    )
    task_resource_id = colander.SchemaNode(
        colander.Integer(),
        missing=None,
    )
    title = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(min=2, max=128)
    )
    deadline = colander.SchemaNode(
        Date()
    )
    reminder_date = colander.SchemaNode(
        Date(),
        missing=None,
        validator=reminder_validator
    )
    reminder_time = colander.SchemaNode(
        Time(),
        missing=None,
    )
    descr = colander.SchemaNode(
        colander.String(),
        missing=None,
    )
    priority = colander.SchemaNode(
        colander.Integer(),
        validator=colander.OneOf([id for id, name in PRIORITIES])
    )
    closed = colander.SchemaNode(
        colander.Boolean(),
        missing=False
    )
