# -*-coding: utf-8 -*-

import colander

from . import(
    ResourceSchema,
    BaseForm,
    BaseSearchForm,
    BaseAssignForm,    
)
from ..resources.accomodations import AccomodationsResource
from ..models.accomodation import Accomodation
from ..models.task import Task
from ..models.note import Note
from ..lib.qb.accomodations import AccomodationsQueryBuilder
from ..lib.utils.common_utils import translate as _
from ..lib.utils.security_utils import get_auth_employee


@colander.deferred
def name_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        accomodation = Accomodation.by_name(value)
        if (
            accomodation
            and str(accomodation.id) != request.params.get('id')
        ):
            raise colander.Invalid(
                node,
                _(u'Accomodation with the same name exists'),
            )
    return colander.All(colander.Length(max=32), validator,)


class _AccomodationSchema(ResourceSchema):
    name = colander.SchemaNode(
        colander.String(),
        validator=name_validator,
    )


class AccomodationForm(BaseForm):
    _schema = _AccomodationSchema

    def submit(self, accomodation=None):
        if not accomodation:
            accomodation = Accomodation(
                resource=AccomodationsResource.create_resource(
                    get_auth_employee(self.request)
                )
            )
        else:
            accomodation.resource.notes = []
            accomodation.resource.tasks = []
        accomodation.name = self._controls.get('name')
        for id in self._controls.get('note_id'):
            note = Note.get(id)
            accomodation.resource.notes.append(note)
        for id in self._controls.get('task_id'):
            task = Task.get(id)
            accomodation.resource.tasks.append(task)
        return accomodation


class AccomodationSearchForm(BaseSearchForm):
    _qb = AccomodationsQueryBuilder


class AccomodationAssignForm(BaseAssignForm):
    def submit(self, ids):
        for id in ids:
            accomodation = Accomodation.get(id)
            accomodation.resource.maintainer_id = self._controls.get(
                'maintainer_id'
            )
