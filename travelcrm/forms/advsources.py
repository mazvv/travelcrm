# -*-coding: utf-8 -*-

import colander

from . import (
    ResourceSchema,
    BaseForm,
    BaseSearchForm,
    BaseAssignForm,
)
from ..resources.advsources import AdvsourcesResource
from ..models.advsource import Advsource
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.advsources import AdvsourcesQueryBuilder
from ..lib.utils.common_utils import translate as _
from ..lib.utils.security_utils import get_auth_employee


@colander.deferred
def name_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        advsource = Advsource.by_name(value)
        if (
            advsource
            and str(advsource.id) != request.params.get('id')
        ):
            raise colander.Invalid(
                node,
                _(u'Advertise source with the same name exists'),
            )
    return colander.All(colander.Length(max=32), validator,)


class _AdvsourceSchema(ResourceSchema):
    name = colander.SchemaNode(
        colander.String(),
        validator=name_validator,
    )


class AdvsourceForm(BaseForm):
    _schema = _AdvsourceSchema

    def submit(self, advsource=None):
        if not advsource:
            advsource = Advsource(
                resource=AdvsourcesResource.create_resource(
                    get_auth_employee(self.request)
                )
            )
        else:
            advsource.resource.notes = []
            advsource.resource.tasks = []
        advsource.name = self._controls.get('name')
        for id in self._controls.get('note_id'):
            note = Note.get(id)
            advsource.resource.notes.append(note)
        for id in self._controls.get('task_id'):
            task = Task.get(id)
            advsource.resource.tasks.append(task)
        return advsource


class AdvsourceSearchForm(BaseSearchForm):
    _qb = AdvsourcesQueryBuilder


class AdvsourceAssignForm(BaseAssignForm):
    def submit(self, ids):
        for id in ids:
            advsource = Advsource.get(id)
            advsource.resource.maintainer_id = self._controls.get(
                'maintainer_id'
            )
