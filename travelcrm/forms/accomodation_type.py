# -*-coding: utf-8 -*-

import colander

from . import(
    ResourceSchema, 
    BaseForm,
    BaseSearchForm,
)
from ..resources.accomodation_type import AccomodationTypeResource
from ..models.accomodation_type import AccomodationType
from ..models.task import Task
from ..models.note import Note
from ..lib.qb.accomodation_type import AccomodationTypeQueryBuilder
from ..lib.utils.common_utils import translate as _


@colander.deferred
def name_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        accomodation_type = AccomodationType.by_name(value)
        if (
            accomodation_type
            and str(accomodation_type.id) != request.params.get('id')
        ):
            raise colander.Invalid(
                node,
                _(u'Room category with the same name exists'),
            )
    return colander.All(colander.Length(max=32), validator,)


class _AccomodationTypeSchema(ResourceSchema):
    name = colander.SchemaNode(
        colander.String(),
        validator=name_validator,
    )


class AccomodationTypeForm(BaseForm):
    _schema = _AccomodationTypeSchema

    def submit(self, accomodation_type=None):
        context = AccomodationTypeResource(self.request)
        if not accomodation_type:
            accomodation_type = AccomodationType(
                resource=context.create_resource()
            )
        else:
            accomodation_type.resource.notes = []
            accomodation_type.resource.tasks = []
        accomodation_type.name = self._controls.get('name')
        for id in self._controls.get('note_id'):
            note = Note.get(id)
            accomodation_type.resource.notes.append(note)
        for id in self._controls.get('task_id'):
            task = Task.get(id)
            accomodation_type.resource.tasks.append(task)
        return accomodation_type


class AccomodationTypeSearchForm(BaseSearchForm):
    _qb = AccomodationTypeQueryBuilder
