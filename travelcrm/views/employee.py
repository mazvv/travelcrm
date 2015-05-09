# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound
from pyramid.response import Response

from ..models import DBSession
from ..models.resource import Resource
from ..models.employee import Employee
from ..models.contact import Contact
from ..models.passport import Passport
from ..models.address import Address
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.employee import EmployeeQueryBuilder
from ..lib.helpers.fields import employees_combogrid_field
from ..lib.utils.common_utils import translate as _

from ..forms.employee import (
    EmployeeSchema,
    EmployeeSearchSchema
)


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.employee.EmployeeResource',
)
class EmployeeView(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/employees/index.mak',
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
        schema = EmployeeSearchSchema().bind(request=self.request)
        controls = schema.deserialize(self.request.params.mixed())
        qb = EmployeeQueryBuilder(self.context)
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
        renderer='travelcrm:templates/employees/form.mak',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            employee = Employee.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': employee.id}
                )
            )
        result = self.edit()
        result.update({
            'title': _(u"View Employee"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        request_method='GET',
        renderer='travelcrm:templates/employees/form.mak',
        permission='add'
    )
    def add(self):
        return {'title': _(u'Add Employee')}

    @view_config(
        name='add',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        schema = EmployeeSchema().bind(request=self.request)

        try:
            controls = schema.deserialize(self.request.params.mixed())
            employee = Employee(
                first_name=controls.get('first_name'),
                last_name=controls.get('last_name'),
                second_name=controls.get('second_name'),
                itn=controls.get('itn'),
                dismissal_date=controls.get('dismissal_date'),
                resource=self.context.create_resource()
            )
            if controls.get('photo'):
                employee.photo = self.request.storage.save(
                    controls.get('photo'),
                    folder='employee',
                    randomize=True
                )
            for id in controls.get('contact_id'):
                contact = Contact.get(id)
                employee.contacts.append(contact)
            for id in controls.get('passport_id'):
                passport = Passport.get(id)
                employee.passports.append(passport)
            for id in controls.get('address_id'):
                address = Address.get(id)
                employee.addresses.append(address)
            for id in controls.get('note_id'):
                note = Note.get(id)
                employee.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                employee.resource.tasks.append(task)

            DBSession.add(employee)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': employee.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        request_method='GET',
        renderer='travelcrm:templates/employees/form.mak',
        permission='edit'
    )
    def edit(self):
        employee = Employee.get(self.request.params.get('id'))
        return {'item': employee, 'title': _(u'Edit Employee')}

    @view_config(
        name='edit',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        schema = EmployeeSchema().bind(request=self.request)
        employee = Employee.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params.mixed())
            employee.first_name = controls.get('first_name')
            employee.last_name = controls.get('last_name')
            employee.second_name = controls.get('second_name')
            employee.itn = controls.get('itn')
            employee.dismissal_date = controls.get('dismissal_date')
            if controls.get('photo') != None:
                employee.photo = self.request.storage.save(
                    controls.get('photo'),
                    folder='employee',
                    randomize=True
                )
            if controls.get('delete_photo'):
                employee.photo = None
            employee.contacts = []
            employee.passports = []
            employee.addresses = []
            employee.resource.notes = []
            employee.resource.tasks = []
            for id in controls.get('contact_id'):
                contact = Contact.get(id)
                employee.contacts.append(contact)
            for id in controls.get('passport_id'):
                passport = Passport.get(id)
                employee.passports.append(passport)
            for id in controls.get('address_id'):
                address = Address.get(id)
                employee.addresses.append(address)
            for id in controls.get('note_id'):
                note = Note.get(id)
                employee.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                employee.resource.tasks.append(task)

            return {
                'success_message': _(u'Saved'),
                'response': employee.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='delete',
        request_method='GET',
        renderer='travelcrm:templates/employees/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Employees'),
            'rid': self.request.params.get('rid')
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
            item = Employee.get(id)
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
            value = resource.employee.id
        return Response(
            employees_combogrid_field(
                self.request, self.request.params.get('name'), value
            )
        )
