# -*-coding: utf-8 -*-

import colander

from . import(
    Date,
    ResourceSchema, 
    BaseForm,
    BaseSearchForm,
)
from ..resources.persons import PersonsResource
from ..models.person import Person
from ..models.contact import Contact
from ..models.passport import Passport
from ..models.address import Address
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.persons import PersonsQueryBuilder


class _PersonSchema(ResourceSchema):
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
    gender = colander.SchemaNode(
        colander.String(),
        missing=None,
    )
    birthday = colander.SchemaNode(
        Date(),
        missing=None,
    )
    subscriber = colander.SchemaNode(
        colander.Boolean(false_choices=("", "0", "false"), true_choices=("1")),
        default=False,
    )
    contact_id = colander.SchemaNode(
        colander.Set(),
        missing=[],
    )
    passport_id = colander.SchemaNode(
        colander.Set(),
        missing=[],
    )
    address_id = colander.SchemaNode(
        colander.Set(),
        missing=[],
    )

    def deserialize(self, cstruct):
        if (
            'address_id' in cstruct
            and not isinstance(cstruct.get('address_id'), list)
        ):
            val = cstruct['address_id']
            cstruct['address_id'] = list()
            cstruct['address_id'].append(val)
        if (
            'contact_id' in cstruct
            and not isinstance(cstruct.get('contact_id'), list)
        ):
            val = cstruct['contact_id']
            cstruct['contact_id'] = list()
            cstruct['contact_id'].append(val)
        if (
            'passport_id' in cstruct
            and not isinstance(cstruct.get('passport_id'), list)
        ):
            val = cstruct['passport_id']
            cstruct['passport_id'] = list()
            cstruct['passport_id'].append(val)

        return super(_PersonSchema, self).deserialize(cstruct)


class PersonForm(BaseForm):
    _schema = _PersonSchema

    def submit(self, person=None):
        context = PersonsResource(self.request)
        if not person:
            person = Person(
                resource=context.create_resource()
            )
        else:
            person.contacts = []
            person.passports = []
            person.addresses = []
            person.resource.notes = []
            person.resource.tasks = []
        person.first_name = self._controls.get('first_name')
        person.last_name = self._controls.get('last_name')
        person.second_name = self._controls.get('second_name')
        person.gender = self._controls.get('gender')
        person.birthday = self._controls.get('birthday')
        person.subscriber = self._controls.get('subscriber')
        for id in self._controls.get('contact_id'):
            contact = Contact.get(id)
            person.contacts.append(contact)
        for id in self._controls.get('passport_id'):
            passport = Passport.get(id)
            person.passports.append(passport)
        for id in self._controls.get('address_id'):
            address = Address.get(id)
            person.addresses.append(address)
        for id in self._controls.get('note_id'):
            note = Note.get(id)
            person.resource.notes.append(note)
        for id in self._controls.get('task_id'):
            task = Task.get(id)
            person.resource.tasks.append(task)
        return person


class PersonSearchForm(BaseSearchForm):
    _qb = PersonsQueryBuilder
