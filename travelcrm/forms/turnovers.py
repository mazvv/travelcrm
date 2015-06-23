# -*-coding: utf-8 -*-

import colander

from . import (
    Date,
    ResourceSearchSchema,
    BaseSearchForm,
)

from ..lib.qb.turnovers import TurnoversQueryBuilder


class _TurnoverSearchSchema(ResourceSearchSchema):
    account_id = colander.SchemaNode(
        colander.Integer(),
        missing=None,
    )
    account_item_id = colander.SchemaNode(
        colander.Integer(),
        missing=None,
    )
    date_from = colander.SchemaNode(
        Date(),
        missing=None,
    )
    date_to = colander.SchemaNode(
        Date(),
        missing=None,
    )


class TurnoverSearchForm(BaseSearchForm):
    _schema = _TurnoverSearchSchema
    _qb = TurnoversQueryBuilder
