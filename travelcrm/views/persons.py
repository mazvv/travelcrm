# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.temporal import Temporal
from ..models.person import Person
from ..models.contact import Contact
from ..models.tcontact import TContact
from ..lib.qb.persons import (
    PersonsQueryBuilder,
    PersonsContactsQueryBuilder
)

from ..forms.persons import PersonSchema
from ..forms.contacts import TContactSchema


log = logging.getLogger(__name__)


class Persons(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.persons.Persons',
        request_method='GET',
        renderer='travelcrm:templates/persons/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.persons.Persons',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        qb = PersonsQueryBuilder(self.context)
        qb.sort_query(
            self.request.params.get('sort'),
            self.request.params.get('order', 'asc')
        )
        qb.page_query(
            int(self.request.params.get('rows')),
            int(self.request.params.get('page'))
        )
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized()
        }

    @view_config(
        name='add',
        context='..resources.persons.Persons',
        request_method='GET',
        renderer='travelcrm:templates/persons/form.mak',
        permission='add'
    )
    def add(self):
        _ = self.request.translate
        temporal = Temporal()
        DBSession.add(temporal)
        return {
            'title': _(u'Add Person'),
            'tid': temporal.id
        }

    @view_config(
        name='add',
        context='..resources.persons.Persons',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        _ = self.request.translate
        schema = PersonSchema().bind(request=self.request)

        try:
            controls = schema.deserialize(self.request.params)
            temporal = Temporal.get(controls.get('tid'))
            person = Person(
                first_name=controls.get('first_name'),
                last_name=controls.get('last_name'),
                second_name=controls.get('second_name'),
                gender=controls.get('gender'),
                birthday=controls.get('birthday'),
                resource=self.context.create_resource(controls.get('status'))
            )
            contacts = temporal.contacts.filter(
                TContact.deleted == False
            )
            for contact in contacts:
                person.contacts.append(
                    Contact(
                        contact_type=contact.contact_type,
                        contact=contact.contact
                    )
                )
            DBSession.add(person)
            return {'success_message': _(u'Saved')}
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.persons.Persons',
        request_method='GET',
        renderer='travelcrm:templates/persons/form.mak',
        permission='edit'
    )
    def edit(self):
        _ = self.request.translate
        person = Person.get(self.request.params.get('id'))
        temporal = Temporal()
        DBSession.add(temporal)
        return {
            'item': person,
            'title': _(u'Edit Person'),
            'tid': temporal.id
        }

    @view_config(
        name='edit',
        context='..resources.persons.Persons',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        _ = self.request.translate
        schema = PersonSchema().bind(request=self.request)
        person = Person.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params)
            temporal = Temporal.get(controls.get('tid'))
            person.first_name = controls.get('first_name')
            person.last_name = controls.get('last_name')
            person.second_name = controls.get('second_name')
            person.gender = controls.get('gender')
            person.birthday = controls.get('birthday')
            person.resource.status = controls.get('status')
            contacts = temporal.contacts
            for contact in contacts:
                if contact.deleted and contact.main_id:
                    DBSession.delete(contact.main)
                elif contact.main_id:
                    contact.main.contact_type = contact.contact_type
                    contact.main.contact = contact.contact
                else:
                    person.contacts.append(
                        Contact(
                            contact_type=contact.contact_type,
                            contact=contact.contact
                        )
                    )

            return {'success_message': _(u'Saved')}
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='delete',
        context='..resources.persons.Persons',
        request_method='GET',
        renderer='travelcrm:templates/persons/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'rid': self.request.params.get('rid')
        }

    @view_config(
        name='delete',
        context='..resources.persons.Persons',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        _ = self.request.translate
        for id in self.request.params.getall('id'):
            person = Person.get(id)
            if person:
                DBSession.delete(person)
        return {'success_message': _(u'Deleted')}

    @view_config(
        name='contacts',
        context='..resources.persons.Persons',
        request_method='GET',
        renderer='travelcrm:templates/persons/contacts.mak',
        permission='view'
    )
    def contacts(self):
        return {}

    @view_config(
        name='contacts',
        context='..resources.persons.Persons',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _contacts(self):
        qb = PersonsContactsQueryBuilder()
        qb.union_temporal(
            self.request.params.get('tid'),
            self.request.params.get('person_id'),
        )
        qb.sort_query(
            self.request.params.get('sort'),
            self.request.params.get('order', 'asc')
        )
        qb.page_query(
            int(self.request.params.get('rows')),
            int(self.request.params.get('page'))
        )
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized()
        }

    @view_config(
        name='add_contact',
        context='..resources.persons.Persons',
        request_method='GET',
        renderer='travelcrm:templates/persons/form_contact.mak',
        permission='add'
    )
    def add_contact(self):
        _ = self.request.translate
        return {'title': _(u'Add Contact')}

    @view_config(
        name='add_contact',
        context='..resources.persons.Persons',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add_contact(self):
        _ = self.request.translate
        schema = TContactSchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params)
            temporal = Temporal.get(controls.get('tid'))
            row = TContact(
                contact_type=controls.get('contact_type'),
                contact=controls.get('contact'),
            )
            temporal.contacts.append(row)
            return {'success_message': _(u'Saved')}
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit_contact',
        context='..resources.persons.Persons',
        request_method='GET',
        renderer='travelcrm:templates/persons/form_contact.mak',
        permission='edit'
    )
    def edit_contact(self):
        _ = self.request.translate
        id = int(self.request.params.get('id'))
        if id < 0:
            item = TContact.get(abs(id))
        else:
            item = Contact.get(id)
        return {
            'item': item,
            'title': _(u'Edit Contact')
        }

    @view_config(
        name='edit_contact',
        context='..resources.persons.Persons',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit_contact(self):
        _ = self.request.translate
        id = int(self.request.params.get('id'))
        row = (
            TContact.get(abs(id)) if id < 0 else Contact.get(id)
        )
        schema = TContactSchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params)
            if isinstance(row, Contact):
                row = TContact(
                    main_id=row.id
                )
                DBSession.add(row)
            row.contact_type = controls.get('contact_type')
            row.contact = controls.get('contact')
            row.temporal_id = controls.get('tid')
            return {'success_message': _(u'Saved')}
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='delete_contact',
        context='..resources.persons.Persons',
        request_method='GET',
        renderer='travelcrm:templates/persons/delete_contact.mak',
        permission='delete'
    )
    def delete_contact(self):
        return {
            'tid': self.request.params.get('tid'),
            'id': self.request.params.get('id')
        }

    @view_config(
        name='delete_contact',
        context='..resources.persons.Persons',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete_contact(self):
        _ = self.request.translate
        for id in self.request.params.getall('id'):
            id = int(id)
            row = (
                TContact.get(abs(id))
                if id < 0 else Contact.get(id)
            )
            if isinstance(row, Contact):
                row = TContact(
                    main_id=row.id,
                    contact_type=row.contact_type,
                    contact=row.contact,
                    temporal_id=self.request.params.get('tid'),
                )
                DBSession.add(row)
            row.deleted = True
        return {'success_message': _(u'Deleted')}
