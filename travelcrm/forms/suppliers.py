# -*-coding: utf-8 -*-

import colander

from . import (
    SelectInteger,
    ResourceSchema,
    ResourceSearchSchema,
    BaseForm,
    BaseSearchForm,
    BaseAssignForm,
)
from ..resources.suppliers import SuppliersResource
from ..models.supplier import Supplier
from ..models.bperson import BPerson
from ..models.supplier_type import SupplierType
from ..models.bank_detail import BankDetail
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.suppliers import SuppliersQueryBuilder
from ..lib.utils.common_utils import translate as _
from ..lib.utils.security_utils import get_auth_employee


@colander.deferred
def name_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        supplier = Supplier.by_name(value)
        if (
            supplier
            and str(supplier.id) != request.params.get('id')
        ):
            raise colander.Invalid(
                node,
                _(u'Supplier with the same name exists'),
            )
    return colander.All(colander.Length(max=32), validator,)


class _SupplierSchema(ResourceSchema):
    name = colander.SchemaNode(
        colander.String(),
        validator=name_validator
    )
    descr = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=255),
        missing=u''
    )
    status = colander.SchemaNode(
        colander.String(),
    )
    supplier_type_id = colander.SchemaNode(
        SelectInteger(SupplierType)
    )
    bperson_id = colander.SchemaNode(
        colander.Set(),
        missing=[],
    )
    bank_detail_id = colander.SchemaNode(
        colander.Set(),
        missing=[],
    )

    def deserialize(self, cstruct):
        if (
            'bperson_id' in cstruct
            and not isinstance(cstruct.get('bperson_id'), list)
        ):
            val = cstruct['bperson_id']
            cstruct['bperson_id'] = list()
            cstruct['bperson_id'].append(val)

        if (
            'bank_detail_id' in cstruct
            and not isinstance(cstruct.get('bank_detail_id'), list)
        ):
            val = cstruct['bank_detail_id']
            cstruct['bank_detail_id'] = list()
            cstruct['bank_detail_id'].append(val)

        return super(_SupplierSchema, self).deserialize(cstruct)


class SupplierForm(BaseForm):
    _schema = _SupplierSchema

    def submit(self, supplier=None):
        if not supplier:
            supplier = Supplier(
                resource=SuppliersResource.create_resource(
                    get_auth_employee(self.request)
                )
            )
        else:
            supplier.bpersons = []
            supplier.banks_details = []
            supplier.resource.notes = []
            supplier.resource.tasks = []
        supplier.supplier_type_id = self._controls.get('supplier_type_id')
        supplier.name = self._controls.get('name')
        supplier.status = self._controls.get('status')
        supplier.descr = self._controls.get('descr')
        for id in self._controls.get('bperson_id'):
            bperson = BPerson.get(id)
            supplier.bpersons.append(bperson)
        for id in self._controls.get('bank_detail_id'):
            bank_detail = BankDetail.get(id)
            supplier.banks_details.append(bank_detail)
        for id in self._controls.get('note_id'):
            note = Note.get(id)
            supplier.resource.notes.append(note)
        for id in self._controls.get('task_id'):
            task = Task.get(id)
            supplier.resource.tasks.append(task)
        return supplier


class _SupplierSearchSchema(ResourceSearchSchema):
    supplier_type_id = colander.SchemaNode(
        colander.Integer(),
        missing=None
    )


class SupplierSearchForm(BaseSearchForm):
    _schema = _SupplierSearchSchema
    _qb = SuppliersQueryBuilder


class SupplierAssignForm(BaseAssignForm):
    def submit(self, ids):
        for id in ids:
            supplier = Supplier.get(id)
            supplier.resource.maintainer_id = self._controls.get(
                'maintainer_id'
            )
