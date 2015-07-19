# -*-coding: utf-8 -*-

import colander

from . import (
    ResourceSearchSchema,
    BaseSearchForm, 
    BaseForm
)

from ..resources.activities import ActivitiesResource
from ..lib.qb.activities import ActivitiesQueryBuilder
from ..lib.utils.resources_utils import get_resource_type_by_resource


class _ActivitiesSearchSchema(ResourceSearchSchema):
    employee_id = colander.SchemaNode(
        colander.Integer(),
    )


class ActivitiesSearchForm(BaseSearchForm):
    _qb = ActivitiesQueryBuilder
    _schema = _ActivitiesSearchSchema
 

class _ActivitiesSettingsSchema(colander.Schema):
    column_index = colander.SchemaNode(
        colander.Integer(),
    )


class ActivitiesSettingsForm(BaseForm):
    _schema = _ActivitiesSettingsSchema

    def submit(self):
        context = ActivitiesResource(self.request)
        rt = get_resource_type_by_resource(context)
        rt.settings = {
            'column_index': self._controls.get('column_index'),
        }
