# -*-coding: utf-8 -*-

import colander

from . import(
    ResourceSchema, 
    BaseForm,
    BaseSearchForm,
)
from ..resources.transports import TransportsResource
from ..models.transport import Transport
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.transports import TransportsQueryBuilder
from ..lib.utils.common_utils import translate as _


@colander.deferred
def name_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        transport = Transport.by_name(value)
        if (
            transport
            and str(transport.id) != request.params.get('id')
        ):
            raise colander.Invalid(
                node,
                _(u'Transport with the same name exists'),
            )
    return colander.All(colander.Length(max=255), validator,)


class _TransportSchema(ResourceSchema):
    name = colander.SchemaNode(
        colander.String(),
        validator=name_validator,
    )


class TransportForm(BaseForm):
    _schema = _TransportSchema

    def submit(self, transport=None):
        context = TransportsResource(self.request)
        if not transport:
            transport = Transport(
                resource=context.create_resource()
            )
        else:
            transport.resource.notes = []
            transport.resource.tasks = []
        transport.name = self._controls.get('name')
        for id in self._controls.get('note_id'):
            note = Note.get(id)
            transport.resource.notes.append(note)
        for id in self._controls.get('task_id'):
            task = Task.get(id)
            transport.resource.tasks.append(task)
        return transport


class TransportSearchForm(BaseSearchForm):
    _qb = TransportsQueryBuilder
