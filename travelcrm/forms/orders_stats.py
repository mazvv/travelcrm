# -*-coding: utf-8 -*-

import colander

from . import (
    ResourceSearchSchema,
    BaseSearchForm, 
    BaseForm
)

from ..resources.orders_stats import OrdersStatsResource
from ..lib.qb.orders_stats import OrdersStatsQueryBuilder
from ..lib.utils.resources_utils import get_resource_type_by_resource


class _OrdersStatsSearchSchema(ResourceSearchSchema):
    period = colander.SchemaNode(
        colander.Integer(),
        missing=7,
    )


class OrdersStatsSearchForm(BaseSearchForm):
    _qb = OrdersStatsQueryBuilder
    _schema = _OrdersStatsSearchSchema

    def get_period(self):
        return self._controls.get('period')
 

class _OrdersStatsSettingsSchema(colander.Schema):
    column_index = colander.SchemaNode(
        colander.Integer(),
    )


class OrdersStatsSettingsForm(BaseForm):
    _schema = _OrdersStatsSettingsSchema

    def submit(self):
        context = OrdersStatsResource(self.request)
        rt = get_resource_type_by_resource(context)
        rt.settings = {
            'column_index': self._controls.get('column_index')
        }
