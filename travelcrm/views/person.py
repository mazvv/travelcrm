# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config, view_defaults
from pyramid.response import Response
from pyramid.httpexceptions import HTTPFound

from ..models import DBSession
from ..models.resource import Resource
from ..models.person import Person
from ..models.contact import Contact
from ..models.passport import Passport
from ..models.address import Address
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.person import PersonQueryBuilder
from ..lib.utils.common_utils import translate as _
from ..lib.helpers.fields import persons_combobox_field

from ..forms.person import (
    PersonSchema, 
    PersonSearchSchema
)


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.person.PersonResource',
)
class PersonView(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/persons/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        schema = PersonSearchSchema().bind(request=self.request)
        controls = schema.deserialize(self.request.params.mixed())
        qb = PersonQueryBuilder(self.context)
        qb.search_simple(controls.get('q'))
        qb.advanced_search(**controls)
        id = self.request.params.get('id')
        if id:
            qb.filter_id(id.split(','))
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
        name='view',
        request_method='GET',
        renderer='travelcrm:templates/persons/form.mak',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            person = Person.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': person.id}
                )
            )
        result = self.edit()
        result.update({
            'title': _(u"View Person"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        request_method='GET',
        renderer='travelcrm:templates/persons/form.mak',
        permission='add'
    )
    def add(self):
        return {
            'title': _(u'Add Person'),
        }

    @view_config(
        name='add',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        schema = PersonSchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params.mixed())
            person = Person(
                first_name=controls.get('first_name'),
                last_name=controls.get('last_name'),
                second_name=controls.get('second_name'),
                gender=controls.get('gender'),
                birthday=controls.get('birthday'),
                subscriber=controls.get('subscriber'),
                resource=self.context.create_resource()
            )
            for id in controls.get('contact_id'):
                contact = Contact.get(id)
                person.contacts.append(contact)
            for id in controls.get('passport_id'):
                passport = Passport.get(id)
                person.passports.append(passport)
            for id in controls.get('address_id'):
                address = Address.get(id)
                person.addresses.append(address)
            for id in controls.get('note_id'):
                note = Note.get(id)
                person.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                person.resource.tasks.append(task)

            DBSession.add(person)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': person.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        request_method='GET',
        renderer='travelcrm:templates/persons/form.mak',
        permission='edit'
    )
    def edit(self):
        person = Person.get(self.request.params.get('id'))
        return {
            'item': person,
            'title': _(u'Edit Person'),
        }

    @view_config(
        name='edit',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        schema = PersonSchema().bind(request=self.request)
        person = Person.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params.mixed())
            person.first_name = controls.get('first_name')
            person.last_name = controls.get('last_name')
            person.second_name = controls.get('second_name')
            person.gender = controls.get('gender')
            person.birthday = controls.get('birthday')
            person.subscriber = controls.get('subscriber')
            person.contacts = []
            person.passports = []
            person.addresses = []
            person.resource.notes = []
            person.resource.tasks = []
            for id in controls.get('contact_id'):
                contact = Contact.get(id)
                person.contacts.append(contact)
            for id in controls.get('passport_id'):
                passport = Passport.get(id)
                person.passports.append(passport)
            for id in controls.get('address_id'):
                address = Address.get(id)
                person.addresses.append(address)
            for id in controls.get('note_id'):
                note = Note.get(id)
                person.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                person.resource.tasks.append(task)
            return {
                'success_message': _(u'Saved'),
                'response': person.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='details',
        request_method='GET',
        renderer='travelcrm:templates/persons/details.mak',
        permission='view'
    )
    def details(self):
        person = Person.get(self.request.params.get('id'))
        return {
            'item': person,
        }

    @view_config(
        name='delete',
        request_method='GET',
        renderer='travelcrm:templates/persons/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'id': self.request.params.get('id')
        }

    @view_config(
        name='delete',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        errors = 0
        for id in self.request.params.getall('id'):
            item = Person.get(id)
            if item:
                DBSession.begin_nested()
                try:
                    DBSession.delete(item)
                    DBSession.commit()
                except:
                    errors += 1
                    DBSession.rollback()
        if errors > 0:
            return {
                'error_message': _(
                    u'Some objects could not be delete'
                ),
            }
        return {'success_message': _(u'Deleted')}

    @view_config(
        name='combobox',
        request_method='POST',
        permission='view'
    )
    def _combobox(self):
        value = None
        resource = Resource.get(self.request.params.get('resource_id'))
        if resource:
            value = resource.person.id
        return Response(
            persons_combobox_field(
                self.request, value, name=self.request.params.get('name')
            )
        )
