# -*-coding: utf-8 -*-

import colander

from . import (
    ResourceSchema,
    Date,
    Time,
)
from ..models.task import Task
from ..lib.utils.common_utils import translate as _


@colander.deferred
def reminder_validator(node, kw):
    request = kw.get('request')

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
        colander.String(),
        validator=colander.OneOf(map(lambda x: x[0], Task.PRIORITY))
    )
    status = colander.SchemaNode(
        colander.String(),
        validator=colander.OneOf(map(lambda x: x[0], Task.STATUS))
    )
