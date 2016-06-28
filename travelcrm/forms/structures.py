# -*-coding: utf-8 -*-

import colander

from . import(
    SelectInteger,
    ResourceSchema, 
    BaseForm,
    ResourceSearchSchema,
    BaseSearchForm,
    BaseAssignForm,
)
from ..resources.structures import StructuresResource
from ..models.structure import Structure
from ..models.contact import Contact
from ..models.address import Address
from ..models.bank_detail import BankDetail
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.structures import StructuresQueryBuilder
from ..lib.bl.employees import get_employee_structure
from ..lib.utils.security_utils import get_auth_employee
from ..lib.utils.common_utils import translate as _


@colander.deferred
def parent_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        if request.params.get('id') and str(value) == request.params.get('id'):
            raise colander.Invalid(
                node,
                _(u'Can not be parent of self'),
            )
    return validator


class _StructureSchema(ResourceSchema):
    parent_id = colander.SchemaNode(
        SelectInteger(Structure),
        missing=None,
        validator=parent_validator
    )
    name = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=128)
    )
    contact_id = colander.SchemaNode(
        colander.Set(),
        missing=[],
    )
    address_id = colander.SchemaNode(
        colander.Set(),
        missing=[],
    )
    bank_detail_id = colander.SchemaNode(
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

        if (
            'address_id' in cstruct
            and not isinstance(cstruct.get('address_id'), list)
        ):
            val = cstruct['address_id']
            cstruct['address_id'] = list()
            cstruct['address_id'].append(val)

        if (
            'bank_detail_id' in cstruct
            and not isinstance(cstruct.get('bank_detail_id'), list)
        ):
            val = cstruct['bank_detail_id']
            cstruct['bank_detail_id'] = list()
            cstruct['bank_detail_id'].append(val)

        return super(_StructureSchema, self).deserialize(cstruct)


class StructureForm(BaseForm):
    _schema = _StructureSchema

    def submit(self, structure=None):
        if not structure:
            employee = get_auth_employee(self.request)
            employee_structure = get_employee_structure(employee)
            structure = Structure(
                company_id=employee_structure.company_id,
                resource=StructuresResource.create_resource(
                    get_auth_employee(self.request)
                )
            )
        else:
            structure.addresses = []
            structure.banks_details = []
            structure.contacts = []
            structure.resource.notes = []
            structure.resource.tasks = []
        structure.name = self._controls.get('name')
        structure.parent_id = self._controls.get('parent_id')
        for id in self._controls.get('contact_id'):
            contact = Contact.get(id)
            structure.contacts.append(contact)
        for id in self._controls.get('address_id'):
            address = Address.get(id)
            structure.addresses.append(address)
        for id in self._controls.get('bank_detail_id'):
            bank_detail = BankDetail.get(id)
            structure.banks_details.append(bank_detail)
        for id in self._controls.get('note_id'):
            note = Note.get(id)
            structure.resource.notes.append(note)
        for id in self._controls.get('task_id'):
            task = Task.get(id)
            structure.resource.tasks.append(task)
        return structure


class _StructureSearchSchema(ResourceSearchSchema):
    with_chain = colander.SchemaNode(
        colander.String(),
        missing=None,
    )
    

class StructureSearchForm(BaseSearchForm):
    _schema = _StructureSearchSchema
    _qb = StructuresQueryBuilder

    def _search(self):
        parent_id = self._controls.get('id')
        self.qb.filter_parent_id(
            parent_id,
            with_chain=self._controls.get('with_chain')
        )


class StructureAssignForm(BaseAssignForm):
    def submit(self, ids):
        for id in ids:
            structure = Structure.get(id)
            structure.resource.maintainer_id = self._controls.get(
                'maintainer_id'
            )
