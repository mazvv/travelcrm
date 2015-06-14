# -*-coding: utf-8 -*-

import colander
from pyramid_storage.extensions import IMAGES
from webhelpers.number import format_data_size

from . import(
    File,
    Date,
    ResourceSchema, 
    BaseForm,
    BaseSearchForm,
)
from ..resources.employees import EmployeesResource
from ..models.employee import Employee
from ..models.address import Address
from ..models.contact import Contact
from ..models.passport import Passport
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.employees import EmployeesQueryBuilder
from ..lib.utils.common_utils import translate as _


UPLOAD_MAX_SIZE = 102400


@colander.deferred
def photo_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        if len(value.file.read()) > UPLOAD_MAX_SIZE:
            raise colander.Invalid(
                node,
                _(u'Max Image Size for Upload is %s')
                % format_data_size(UPLOAD_MAX_SIZE, 'B', 2),
            )
        try:
            request.storage.file_allowed(value, IMAGES)
        except:
            raise colander.Invalid(
                node,
                _(u'Only images allowed'),
            )
        value.file.seek(0)

    return validator


class _EmployeeSchema(ResourceSchema):
    photo = colander.SchemaNode(
        File(),
        missing=None,
        validator=photo_validator
    )
    delete_photo = colander.SchemaNode(
        colander.Boolean(),
        missing=False,
    )
    first_name = colander.SchemaNode(
        colander.String(),
    )
    last_name = colander.SchemaNode(
        colander.String(),
    )
    second_name = colander.SchemaNode(
        colander.String(),
        missing=None
    )
    itn = colander.SchemaNode(
        colander.String(),
        missing=None,
        validator=colander.Length(min=2, max=32)
    )
    dismissal_date = colander.SchemaNode(
        Date(),
        missing=None
    )
    contact_id = colander.SchemaNode(
        colander.Set(),
        missing=[]
    )
    passport_id = colander.SchemaNode(
        colander.Set(),
        missing=[]
    )
    address_id = colander.SchemaNode(
        colander.Set(),
        missing=[]
    )

    def deserialize(self, cstruct):
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

        if (
            'address_id' in cstruct
            and not isinstance(cstruct.get('address_id'), list)
        ):
            val = cstruct['address_id']
            cstruct['address_id'] = list()
            cstruct['address_id'].append(val)

        return super(_EmployeeSchema, self).deserialize(cstruct)


class EmployeeForm(BaseForm):
    _schema = _EmployeeSchema

    def submit(self, employee=None):
        context = EmployeesResource(self.request)
        if not employee:
            employee = Employee(
                resource=context.create_resource()
            )
        else:
            employee.addresses = []
            employee.resource.notes = []
            employee.resource.tasks = []
        employee.first_name = self._controls.get('first_name')
        employee.last_name = self._controls.get('last_name')
        employee.second_name = self._controls.get('second_name')
        employee.itn = self._controls.get('itn')
        employee.dismissal_date = self._controls.get('dismissal_date')

        for id in self._controls.get('contact_id'):
            contact = Contact.get(id)
            employee.contacts.append(contact)
        for id in self._controls.get('passport_id'):
            passport = Passport.get(id)
            employee.passports.append(passport)
        for id in self._controls.get('address_id'):
            address = Address.get(id)
            employee.addresses.append(address)
        for id in self._controls.get('note_id'):
            note = Note.get(id)
            employee.resource.notes.append(note)
        for id in self._controls.get('task_id'):
            task = Task.get(id)
            employee.resource.tasks.append(task)
        return employee


class EmployeeSearchForm(BaseSearchForm):
    _qb = EmployeesQueryBuilder
