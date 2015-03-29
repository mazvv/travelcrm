# -*-coding: utf-8 -*-

import colander

from . import(
    ResourceSchema, 
    BaseForm,
    BaseSearchForm,
)
from ..resources.foodcat import FoodcatResource
from ..models.foodcat import Foodcat
from ..models.task import Task
from ..models.note import Note
from ..lib.qb.foodcat import FoodcatQueryBuilder
from ..lib.utils.common_utils import translate as _


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
        context = FoodcatResource(self.request)
        if not foodcat:
            foodcat = Foodcat(
                resource=context.create_resource()
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
    _qb = FoodcatQueryBuilder
