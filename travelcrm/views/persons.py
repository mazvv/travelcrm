# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.person import Person
from ..models.contact import Contact
from ..models.passport import Passport
from ..lib.qb.persons import PersonsQueryBuilder

from ..forms.persons import PersonSchema


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
        qb.search_simple(
            self.request.params.get('q'),
        )
        qb.advanced_search(
            updated_from=self.request.params.get('updated_from'),
            updated_to=self.request.params.get('updated_to'),
            modifier_id=self.request.params.get('modifier_id'),
            status=self.request.params.get('status'),
        )
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
        name='add',
        context='..resources.persons.Persons',
        request_method='GET',
        renderer='travelcrm:templates/persons/form.mak',
        permission='add'
    )
    def add(self):
        _ = self.request.translate
        return {
            'title': _(u'Add Person'),
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
            person = Person(
                first_name=controls.get('first_name'),
                last_name=controls.get('last_name'),
                second_name=controls.get('second_name'),
                gender=controls.get('gender'),
                birthday=controls.get('birthday'),
                resource=self.context.create_resource(controls.get('status'))
            )
            if self.request.params.getall('contact_id'):
                person.contacts = (
                    DBSession.query(Contact)
                    .filter(
                        Contact.id.in_(
                            self.request.params.getall('contact_id')
                        )
                    )
                    .all()
                )
            if self.request.params.getall('passport_id'):
                person.passports = (
                    DBSession.query(Passport)
                    .filter(
                        Passport.id.in_(
                            self.request.params.getall('passport_id')
                        )
                    )
                    .all()
                )
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
        context='..resources.persons.Persons',
        request_method='GET',
        renderer='travelcrm:templates/persons/form.mak',
        permission='edit'
    )
    def edit(self):
        _ = self.request.translate
        person = Person.get(self.request.params.get('id'))
        return {
            'item': person,
            'title': _(u'Edit Person'),
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
            person.first_name = controls.get('first_name')
            person.last_name = controls.get('last_name')
            person.second_name = controls.get('second_name')
            person.gender = controls.get('gender')
            person.birthday = controls.get('birthday')
            person.resource.status = controls.get('status')
            if self.request.params.getall('contact_id'):
                person.contacts = (
                    DBSession.query(Contact)
                    .filter(
                        Contact.id.in_(
                            self.request.params.getall('contact_id')
                        )
                    )
                    .all()
                )
            else:
                person.contacts = []
            if self.request.params.getall('passport_id'):
                person.passports = (
                    DBSession.query(Passport)
                    .filter(
                        Passport.id.in_(
                            self.request.params.getall('passport_id')
                        )
                    )
                    .all()
                )
            else:
                person.passports = []
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
        name='delete',
        context='..resources.persons.Persons',
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
