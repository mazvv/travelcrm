# -*-coding: utf-8 -*-

import colander

from . import (
    ResourceSearchSchema, 
    BaseSearchForm
)
from ..lib.qb.notifications import NotificationsQueryBuilder


class _NotificationSearchSchema(ResourceSearchSchema):
    employee_id = colander.SchemaNode(
        colander.Integer(),
    )
    status = colander.SchemaNode(
        colander.String(),
        missing=None
    )


class NotificationSearchForm(BaseSearchForm):
    _schema = _NotificationSearchSchema
    _qb = NotificationsQueryBuilder
