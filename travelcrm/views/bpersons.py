# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.bperson import BPerson
from ..models.contact import Contact
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.bpersons import BPersonsQueryBuilder
from ..lib.utils.common_utils import translate as _

from ..forms.bpersons import BPersonSchema


log = logging.getLogger(__name__)


class BPersons(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.bpersons.BPersons',
        request_method='GET',
        renderer='travelcrm:templates/bpersons/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.bpersons.BPersons',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        qb = BPersonsQueryBuilder(self.context)
        qb.search_simple(
            self.request.params.get('q'),
        )
        qb.advanced_search(
            **self.request.params.mixed()
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
        name='view',
        context='..resources.bpersons.BPersons',
        request_method='GET',
        renderer='travelcrm:templates/bpersons/form.mak',
        permission='view'
    )
    def view(self):
        result = self.edit()
        result.update({
            'title': _(u"View Business Person"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        context='..resources.bpersons.BPersons',
        request_method='GET',
        renderer='travelcrm:templates/bpersons/form.mak',
        permission='add'
    )
    def add(self):
        return {
            'title': _(u'Add Business Person'),
        }

    @view_config(
        name='add',
        context='..resources.bpersons.BPersons',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        schema = BPersonSchema().bind(request=self.request)

        try:
            controls = schema.deserialize(self.request.params.mixed())
            bperson = BPerson(
                first_name=controls.get('first_name'),
                last_name=controls.get('last_name'),
                second_name=controls.get('second_name'),
                position_name=controls.get('position_name'),
                resource=self.context.create_resource()
            )
            for id in controls.get('contact_id'):
                contact = Contact.get(id)
                bperson.contacts.append(contact)
            for id in controls.get('note_id'):
                note = Note.get(id)
                bperson.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                bperson.resource.tasks.append(task)
            DBSession.add(bperson)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': bperson.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.bpersons.BPersons',
        request_method='GET',
        renderer='travelcrm:templates/bpersons/form.mak',
        permission='edit'
    )
    def edit(self):
        bperson = BPerson.get(self.request.params.get('id'))
        return {
            'item': bperson,
            'title': _(u'Edit Business Person'),
        }

    @view_config(
        name='edit',
        context='..resources.bpersons.BPersons',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        schema = BPersonSchema().bind(request=self.request)
        bperson = BPerson.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params.mixed())
            bperson.first_name = controls.get('first_name')
            bperson.last_name = controls.get('last_name')
            bperson.second_name = controls.get('second_name')
            bperson.position_name = controls.get('position_name')
            bperson.contacts = []
            bperson.resource.notes = []
            bperson.resource.tasks = []
            for id in controls.get('contact_id'):
                contact = Contact.get(id)
                bperson.contacts.append(contact)
            for id in controls.get('note_id'):
                note = Note.get(id)
                bperson.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                bperson.resource.tasks.append(task)
            return {
                'success_message': _(u'Saved'),
                'response': bperson.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='copy',
        context='..resources.bpersons.BPersons',
        request_method='GET',
        renderer='travelcrm:templates/bpersons/form.mak',
        permission='add'
    )
    def copy(self):
        bperson = BPerson.get(self.request.params.get('id'))
        return {
            'item': bperson,
            'title': _(u"Copy Business Person")
        }

    @view_config(
        name='copy',
        context='..resources.bpersons.BPersons',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _copy(self):
        return self._add()

    @view_config(
        name='details',
        context='..resources.bpersons.BPersons',
        request_method='GET',
        renderer='travelcrm:templates/bpersons/details.mak',
        permission='view'
    )
    def details(self):
        bperson = BPerson.get(self.request.params.get('id'))
        return {
            'item': bperson,
        }

    @view_config(
        name='delete',
        context='..resources.bpersons.BPersons',
        request_method='GET',
        renderer='travelcrm:templates/bpersons/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Business Persons'),
            'id': self.request.params.get('id')
        }

    @view_config(
        name='delete',
        context='..resources.bpersons.BPersons',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        errors = 0
        for id in self.request.params.getall('id'):
            item = BPerson.get(id)
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
