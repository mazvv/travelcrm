# -*-coding: utf-8 -*-

import colander

from . import (
    ResourceSchema,
    BaseForm,
    BaseSearchForm,
)
from ..resources.advsource import AdvsourceResource
from ..models.advsource import Advsource
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.advsource import AdvsourceQueryBuilder
from ..lib.utils.common_utils import translate as _


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
        context = AdvsourceResource(self.request)
        if not advsource:
            advsource = Advsource(
                resource=context.create_resource()
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
    _qb = AdvsourceQueryBuilder
