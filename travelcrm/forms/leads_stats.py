# -*-coding: utf-8 -*-

import colander

from . import (
    ResourceSearchSchema,
    BaseSearchForm, 
    BaseForm
)

from ..resources.leads_stats import LeadsStatsResource
from ..lib.qb.leads_stats import LeadsStatsQueryBuilder
from ..lib.utils.resources_utils import get_resource_type_by_resource


class _LeadsStatsSearchSchema(ResourceSearchSchema):
    period = colander.SchemaNode(
        colander.Integer(),
        missing=7,
    )


class LeadsStatsSearchForm(BaseSearchForm):
    _qb = LeadsStatsQueryBuilder
    _schema = _LeadsStatsSearchSchema

    def get_period(self):
        return self._controls.get('period')
 

class _LeadsStatsSettingsSchema(colander.Schema):
    column_index = colander.SchemaNode(
        colander.Integer(),
    )


class LeadsStatsSettingsForm(BaseForm):
    _schema = _LeadsStatsSettingsSchema

    def submit(self):
        context = LeadsStatsResource(self.request)
        rt = get_resource_type_by_resource(context)
        rt.settings = {
            'column_index': self._controls.get('column_index')
        }
