# -*-coding: utf-8 -*-

import colander
from pyramid_storage.extensions import IMAGES

from . import(
    File,
    ResourceSchema, 
    BaseForm,
    BaseSearchForm,
    BaseAssignForm,
)
from ..resources.employees import EmployeesResource
from ..resources.uploads import UploadsResource
from ..models.employee import Employee
from ..models.address import Address
from ..models.contact import Contact
from ..models.passport import Passport
from ..models.note import Note
from ..models.task import Task
from ..models.upload import Upload
from ..lib.qb.employees import EmployeesQueryBuilder
from ..lib.bl.storages import (
    is_allowed_file_size,
    get_file_size
)
from ..lib.utils.common_utils import get_storage_dir
from ..lib.utils.common_utils import translate as _
from ..lib.utils.security_utils import get_auth_employee


@colander.deferred
def photo_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        if not is_allowed_file_size(value.file):
            raise colander.Invalid(
                node,
                _(u'File is too big')
            )
        try:
            request.storage.file_allowed(value, IMAGES)
        except:
            raise colander.Invalid(
                node,
                _(u'Only images allowed'),
            )
        value.file.seek(0)

    return colander.All(validator,)


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
    upload_id = colander.SchemaNode(
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

        if (
            'upload_id' in cstruct
            and not isinstance(cstruct.get('upload_id'), list)
        ):
            val = cstruct['upload_id']
            cstruct['upload_id'] = list()
            cstruct['upload_id'].append(val)

        return super(_EmployeeSchema, self).deserialize(cstruct)


class EmployeeForm(BaseForm):
    _schema = _EmployeeSchema

    def submit(self, employee=None):
        if not employee:
            employee = Employee(
                resource=EmployeesResource.create_resource(
                    get_auth_employee(self.request)
                )
            )
        else:
            employee.addresses = []
            employee.contacts = []
            employee.passports = []
            employee.uploads = []
            employee.resource.notes = []
            employee.resource.tasks = []
        employee.first_name = self._controls.get('first_name')
        employee.last_name = self._controls.get('last_name')
        employee.second_name = self._controls.get('second_name')
        employee.itn = self._controls.get('itn')

        if self._controls.get('photo') is not None:
            employee.photo = Upload(
                resource=UploadsResource.create_resource(
                    get_auth_employee(self.request)
                ),
                name=self._controls.get('photo').filename,
                path = self.request.storage.save(
                    self._controls.get('photo'),
                    folder=get_storage_dir(),
                    randomize=True
                ),
                size=get_file_size(self._controls.get('photo').file),
                media_type=self._controls.get('photo').type
            )
            
        if self._controls.get('delete_photo'):
            employee.photo = None
        for id in self._controls.get('contact_id'):
            contact = Contact.get(id)
            employee.contacts.append(contact)
        for id in self._controls.get('passport_id'):
            passport = Passport.get(id)
            employee.passports.append(passport)
        for id in self._controls.get('address_id'):
            address = Address.get(id)
            employee.addresses.append(address)
        for id in self._controls.get('upload_id'):
            upload = Upload.get(id)
            employee.uploads.append(upload)
        for id in self._controls.get('note_id'):
            note = Note.get(id)
            employee.resource.notes.append(note)
        for id in self._controls.get('task_id'):
            task = Task.get(id)
            employee.resource.tasks.append(task)
        return employee


class EmployeeSearchForm(BaseSearchForm):
    _qb = EmployeesQueryBuilder


class EmployeeAssignForm(BaseAssignForm):
    def submit(self, ids):
        for id in ids:
            employee = Employee.get(id)
            employee.resource.maintainer_id = self._controls.get(
                'maintainer_id'
            )
