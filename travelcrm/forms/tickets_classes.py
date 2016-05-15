# -*-coding: utf-8 -*-

import colander

from . import(
    ResourceSchema, 
    BaseForm,
    BaseSearchForm,
    BaseAssignForm,
)
from ..resources.tickets_classes import TicketsClassesResource
from ..models.ticket_class import TicketClass
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.tickets_classes import TicketsClassesQueryBuilder
from ..lib.utils.common_utils import translate as _
from ..lib.utils.security_utils import get_auth_employee


@colander.deferred
def name_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        ticket_class = TicketClass.by_name(value)
        if (
            ticket_class
            and str(ticket_class.id) != request.params.get('id')
        ):
            raise colander.Invalid(
                node,
                _(u'Transport with the same name exists'),
            )
    return colander.All(colander.Length(max=255), validator,)


class _TicketClassSchema(ResourceSchema):
    name = colander.SchemaNode(
        colander.String(),
        validator=name_validator,
    )


class TicketClassForm(BaseForm):
    _schema = _TicketClassSchema

    def submit(self, ticket_class=None):
        if not ticket_class:
            ticket_class = TicketClass(
                resource=TicketsClassesResource.create_resource(
                    get_auth_employee(self.request)
                )
            )
        else:
            ticket_class.resource.notes = []
            ticket_class.resource.tasks = []
        ticket_class.name = self._controls.get('name')
        for id in self._controls.get('note_id'):
            note = Note.get(id)
            ticket_class.resource.notes.append(note)
        for id in self._controls.get('task_id'):
            task = Task.get(id)
            ticket_class.resource.tasks.append(task)
        return ticket_class


class TicketClassSearchForm(BaseSearchForm):
    _qb = TicketsClassesQueryBuilder


class TicketClassAssignForm(BaseAssignForm):
    def submit(self, ids):
        for id in ids:
            ticket_class = TicketClass.get(id)
            ticket_class.resource.maintainer_id = self._controls.get(
                'maintainer_id'
            )
