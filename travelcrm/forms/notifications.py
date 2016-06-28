# -*-coding: utf-8 -*-

import colander

from . import (
    SelectInteger,
    ResourceSearchSchema, 
    BaseSearchForm
)
from ..models.employee import Employee
from ..lib.qb.notifications import NotificationsQueryBuilder


class _NotificationSearchSchema(ResourceSearchSchema):
    employee_id = colander.SchemaNode(
        SelectInteger(Employee)
    )
    status = colander.SchemaNode(
        colander.String(),
        missing=None
    )


class NotificationSearchForm(BaseSearchForm):
    _schema = _NotificationSearchSchema
    _qb = NotificationsQueryBuilder
