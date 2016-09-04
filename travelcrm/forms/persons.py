# -*-coding: utf-8 -*-

import colander

from . import(
    Date,
    SelectInteger,
    ResourceSchema,
    BaseForm,
    BaseSearchForm,
    BaseAssignForm,
)
from ..resources.persons import PersonsResource
from ..models.person import Person
from ..models.tag import Tag
from ..models.contact import Contact
from ..models.passport import Passport
from ..models.address import Address
from ..models.person_category import PersonCategory
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.persons import PersonsQueryBuilder
from ..lib.utils.security_utils import get_auth_employee
from ..lib.utils.common_utils import translate as _


class _PersonSchema(ResourceSchema):
    MAX_TAGS = 5

    person_category_id = colander.SchemaNode(
        SelectInteger(PersonCategory),
        missing=None,
    )
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
    tag_id = colander.SchemaNode(
        colander.Set(),
        validator=colander.Length(
            max=MAX_TAGS, max_err=_(u'Max %s tags allowed') % MAX_TAGS
        ),
        missing=[],
    )

    email_subscription = colander.SchemaNode(
        colander.Boolean(),
        missing=False,
    )
    sms_subscription = colander.SchemaNode(
        colander.Boolean(),
        missing=False,
    )
    descr = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=255),
        missing=None
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
            'tag_id' in cstruct
            and not isinstance(cstruct.get('tag_id'), list)
        ):
            val = cstruct['tag_id']
            cstruct['tag_id'] = list()
            cstruct['tag_id'].append(val)
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
        if not person:
            person = Person(
                resource=PersonsResource.create_resource(
                    get_auth_employee(self.request)
                )
            )
        else:
            person.contacts = []
            person.resource.tags = []
            person.passports = []
            person.addresses = []
            person.resource.notes = []
            person.resource.tasks = []
        person.person_category_id = self._controls.get('person_category_id')
        person.first_name = self._controls.get('first_name')
        person.last_name = self._controls.get('last_name')
        person.second_name = self._controls.get('second_name')
        person.gender = self._controls.get('gender')
        person.email_subscription = self._controls.get('email_subscription')
        person.sms_subscription = self._controls.get('sms_subscription')
        person.birthday = self._controls.get('birthday')
        person.descr = self._controls.get('descr')
        for id in self._controls.get('tag_id'):
            tag = Tag.get(id)
            person.resource.tags.append(tag)
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


class PersonAssignForm(BaseAssignForm):
    def submit(self, ids):
        for id in ids:
            person = Person.get(id)
            person.resource.maintainer_id = self._controls.get('maintainer_id')
