# -*-coding: utf-8 -*-

import colander

from . import (
    ResourceSchema, 
    BaseForm, 
    BaseSearchForm,
    BaseAssignForm,
)
from ..resources.hotelcats import HotelcatsResource
from ..models.hotelcat import Hotelcat
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.hotelcats import HotelcatsQueryBuilder
from ..lib.utils.common_utils import translate as _
from ..lib.utils.security_utils import get_auth_employee


@colander.deferred
def name_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        hotelcat = Hotelcat.by_name(value)
        if (
            hotelcat
            and str(hotelcat.id) != request.params.get('id')
        ):
            raise colander.Invalid(
                node,
                _(u'Hotel category with the same name exists'),
            )
    return colander.All(colander.Length(max=32), validator,)


class _HotelcatSchema(ResourceSchema):
    name = colander.SchemaNode(
        colander.String(),
        validator=name_validator,
    )


class HotelcatForm(BaseForm):
    _schema = _HotelcatSchema

    def submit(self, hotelcat=None):
        if not hotelcat:
            hotelcat = Hotelcat(
                resource=HotelcatsResource.create_resource(
                    get_auth_employee(self.request)
                )
            )
        else:
            hotelcat.resource.notes = []
            hotelcat.resource.tasks = []
        hotelcat.name = self._controls.get('name')
        for id in self._controls.get('note_id'):
            note = Note.get(id)
            hotelcat.resource.notes.append(note)
        for id in self._controls.get('task_id'):
            task = Task.get(id)
            hotelcat.resource.tasks.append(task)
        return hotelcat


class HotelcatSearchForm(BaseSearchForm):
    _qb = HotelcatsQueryBuilder


class HotelcatAssignForm(BaseAssignForm):
    def submit(self, ids):
        for id in ids:
            hotelcat = Hotelcat.get(id)
            hotelcat.resource.maintainer_id = self._controls.get(
                'maintainer_id'
            )
