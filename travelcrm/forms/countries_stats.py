# -*-coding: utf-8 -*-

import colander

from . import (
    ResourceSearchSchema,
    BaseSearchForm, 
    BaseForm
)

from ..resources.countries_stats import CountriesStatsResource
from ..lib.qb.countries_stats import CountriesStatsQueryBuilder
from ..lib.utils.resources_utils import get_resource_type_by_resource


class _CountriesStatsSearchSchema(ResourceSearchSchema):
    period = colander.SchemaNode(
        colander.Integer(),
        missing=7,
    )


class CountriesStatsSearchForm(BaseSearchForm):
    _qb = CountriesStatsQueryBuilder
    _schema = _CountriesStatsSearchSchema

    def get_period(self):
        return self._controls.get('period')
 

class _CountriesStatsSettingsSchema(colander.Schema):
    column_index = colander.SchemaNode(
        colander.Integer(),
    )


class CountriesStatsSettingsForm(BaseForm):
    _schema = _CountriesStatsSettingsSchema

    def submit(self):
        context = CountriesStatsResource(self.request)
        rt = get_resource_type_by_resource(context)
        rt.settings = {
            'column_index': self._controls.get('column_index')
        }
