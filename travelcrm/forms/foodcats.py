# -*-coding: utf-8 -*-

import colander

from . import(
    ResourceSchema, 
    BaseForm,
    BaseSearchForm,
    BaseAssignForm,
)
from ..resources.foodcats import FoodcatsResource
from ..models.foodcat import Foodcat
from ..models.task import Task
from ..models.note import Note
from ..lib.qb.foodcats import FoodcatsQueryBuilder
from ..lib.utils.common_utils import translate as _
from ..lib.utils.security_utils import get_auth_employee


@colander.deferred
def name_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        foodcat = Foodcat.by_name(value)
        if (
            foodcat
            and str(foodcat.id) != request.params.get('id')
        ):
            raise colander.Invalid(
                node,
                _(u'Food category with the same name exists'),
            )
    return colander.All(colander.Length(max=32), validator,)


class _FoodcatSchema(ResourceSchema):
    name = colander.SchemaNode(
        colander.String(),
        validator=name_validator,
    )


class FoodcatForm(BaseForm):
    _schema = _FoodcatSchema

    def submit(self, foodcat=None):
        if not foodcat:
            foodcat = Foodcat(
                resource=FoodcatsResource.create_resource(
                    get_auth_employee(self.request)
                )
            )
        else:
            foodcat.resource.notes = []
            foodcat.resource.tasks = []
        foodcat.name = self._controls.get('name')
        for id in self._controls.get('note_id'):
            note = Note.get(id)
            foodcat.resource.notes.append(note)
        for id in self._controls.get('task_id'):
            task = Task.get(id)
            foodcat.resource.tasks.append(task)
        return foodcat


class FoodcatSearchForm(BaseSearchForm):
    _qb = FoodcatsQueryBuilder


class FoodcatAssignForm(BaseAssignForm):
    def submit(self, ids):
        for id in ids:
            foodcat = Foodcat.get(id)
            foodcat.resource.maintainer_id = self._controls.get(
                'maintainer_id'
            )
    
