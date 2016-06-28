# -*-coding: utf-8 -*-

import colander

from . import(
    SelectInteger,
    ResourceSchema, 
    BaseForm,
    BaseSearchForm,
    BaseAssignForm,
)
from ..resources.positions import PositionsResource
from ..models import DBSession
from ..models.position import Position
from ..models.structure import Structure
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.positions import PositionsQueryBuilder
from ..lib.utils.common_utils import translate as _
from ..lib.utils.security_utils import get_auth_employee


@colander.deferred
def name_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        position = (
            DBSession.query(Position)
            .filter(
                Position.name == value,
                Position.structure_id == request.params.get('structure_id')
            )
            .first()
        )
        if (
            position
            and (
                str(position.id) != request.params.get('id')
                or (
                    str(position.id) == request.params.get('id')
                    and request.view_name == 'copy'
                )
            )
        ):
            raise colander.Invalid(
                node,
                _(u'Position with the same name for structure exists'),
            )
    return colander.All(colander.Length(max=128), validator,)


class _PositionSchema(ResourceSchema):
    structure_id = colander.SchemaNode(
        SelectInteger(Structure),
    )
    name = colander.SchemaNode(
        colander.String(),
        validator=name_validator
    )

class PositionForm(BaseForm):
    _schema = _PositionSchema

    def submit(self, position=None):
        if not position:
            position = Position(
                resource=PositionsResource.create_resource(
                    get_auth_employee(self.request)
                )
            )
        else:
            position.addresses = []
            position.resource.notes = []
            position.resource.tasks = []
        position.structure_id = self._controls.get('structure_id')
        position.name = self._controls.get('name')
        for id in self._controls.get('note_id'):
            note = Note.get(id)
            position.resource.notes.append(note)
        for id in self._controls.get('task_id'):
            task = Task.get(id)
            position.resource.tasks.append(task)
        return position


class PositionSearchForm(BaseSearchForm):
    _qb = PositionsQueryBuilder


class PositionAssignForm(BaseAssignForm):
    def submit(self, ids):
        for id in ids:
            position = Position.get(id)
            position.resource.maintainer_id = self._controls.get(
                'maintainer_id'
            )
