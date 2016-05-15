# -*-coding: utf-8 -*-

import colander

from . import(
    ResourceSchema, 
    BaseForm,
    BaseSearchForm,
    BaseAssignForm,
)
from ..resources.bpersons import BPersonsResource
from ..models.bperson import BPerson
from ..models.contact import Contact
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.bpersons import BPersonsQueryBuilder
from ..lib.utils.security_utils import get_auth_employee


class _BPersonSchema(ResourceSchema):
    first_name = colander.SchemaNode(
        colander.String(),
    )
    last_name = colander.SchemaNode(
        colander.String(),
        missing=u""
    )
    second_name = colander.SchemaNode(
        colander.String(),
        missing=u""
    )
    position_name = colander.SchemaNode(
        colander.String(),
    )
    status = colander.SchemaNode(
        colander.String(),
    )
    descr = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=255),
        missing=u''
    )
    contact_id = colander.SchemaNode(
        colander.Set(),
        missing=[],
    )

    def deserialize(self, cstruct):
        if (
            'contact_id' in cstruct
            and not isinstance(cstruct.get('contact_id'), list)
        ):
            val = cstruct['contact_id']
            cstruct['contact_id'] = list()
            cstruct['contact_id'].append(val)

        return super(_BPersonSchema, self).deserialize(cstruct)


class BPersonForm(BaseForm):
    _schema = _BPersonSchema

    def submit(self, bperson=None):
        if not bperson:
            bperson = BPerson(
                resource=BPersonsResource.create_resource(
                    get_auth_employee(self.request)
                )
            )
        else:
            bperson.contacts = []
            bperson.resource.notes = []
            bperson.resource.tasks = []
        bperson.first_name = self._controls.get('first_name')
        bperson.last_name = self._controls.get('last_name')
        bperson.second_name = self._controls.get('second_name')
        bperson.position_name = self._controls.get('position_name')
        bperson.status = self._controls.get('status')
        bperson.descr = self._controls.get('descr')
        for id in self._controls.get('contact_id'):
            contact = Contact.get(id)
            bperson.contacts.append(contact)
        for id in self._controls.get('note_id'):
            note = Note.get(id)
            bperson.resource.notes.append(note)
        for id in self._controls.get('task_id'):
            task = Task.get(id)
            bperson.resource.tasks.append(task)
        return bperson


class BPersonSearchForm(BaseSearchForm):
    _qb = BPersonsQueryBuilder


class BPersonAssignForm(BaseAssignForm):
    def submit(self, ids):
        for id in ids:
            bperson = BPerson.get(id)
            bperson.resource.maintainer_id = self._controls.get(
                'maintainer_id'
            )
