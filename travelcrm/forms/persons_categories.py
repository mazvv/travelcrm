# -*-coding: utf-8 -*-

import colander

from . import(
    ResourceSchema, 
    BaseForm,
    BaseSearchForm,
    BaseAssignForm,
)
from ..resources.persons_categories import PersonsCategoriesResource
from ..models.person_category import PersonCategory
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.persons_categories import PersonsCategoriesQueryBuilder
from ..lib.utils.common_utils import translate as _
from ..lib.utils.security_utils import get_auth_employee


@colander.deferred
def name_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        person_category = PersonCategory.by_name(value)
        if (
            person_category
            and str(person_category.id) != request.params.get('id')
        ):
            raise colander.Invalid(
                node,
                _(u'Person Category with the same name exists'),
            )
    return colander.All(colander.Length(max=255), validator,)


class _PersonCategorySchema(ResourceSchema):
    name = colander.SchemaNode(
        colander.String(),
        validator=name_validator,
    )


class PersonCategoryForm(BaseForm):
    _schema = _PersonCategorySchema

    def submit(self, person_category=None):
        if not person_category:
            person_category = PersonCategory(
                resource=PersonsCategoriesResource.create_resource(
                    get_auth_employee(self.request)
                )
            )
        else:
            person_category.resource.notes = []
            person_category.resource.tasks = []
        person_category.name = self._controls.get('name')
        for id in self._controls.get('note_id'):
            note = Note.get(id)
            person_category.resource.notes.append(note)
        for id in self._controls.get('task_id'):
            task = Task.get(id)
            person_category.resource.tasks.append(task)
        return person_category


class PersonCategorySearchForm(BaseSearchForm):
    _qb = PersonsCategoriesQueryBuilder


class PersonCategoryAssignForm(BaseAssignForm):
    def submit(self, ids):
        for id in ids:
            person_category = PersonCategory.get(id)
            person_category.resource.maintainer_id = self._controls.get(
                'maintainer_id'
            )
