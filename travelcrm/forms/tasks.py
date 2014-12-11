# -*-coding: utf-8 -*-

import colander

from . import (
    ResourceSchema,
    DateTime
)
from ..lib.utils.common_utils import parse_datetime
from ..lib.utils.common_utils import translate as _


@colander.deferred
def reminder_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        deadline = parse_datetime(request.params.get('deadline'))
        if value and deadline <= value:
            raise colander.Invalid(
                node,
                _(u'Remainder must be earlier than Deadline'),
            )
    return colander.All(validator)


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
        DateTime()
    )
    reminder = colander.SchemaNode(
        DateTime(),
        validator=reminder_validator
    )
    descr = colander.SchemaNode(
        colander.String(),
        missing=None,
    )
    closed = colander.SchemaNode(
        colander.Boolean(false_choices=("", "0", "false"), true_choices=("1")),
        default=False,
    )
