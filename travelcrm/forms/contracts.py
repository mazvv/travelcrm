# -*-coding: utf-8 -*-

import colander

from . import(
    SelectInteger,
    Date,
    ResourceSchema, 
    BaseForm,
    BaseSearchForm,
    BaseAssignForm,
)
from ..resources.contracts import ContractsResource
from ..models.supplier import Supplier
from ..models.contract import Contract
from ..models.commission import Commission
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.contracts import ContractsQueryBuilder
from ..lib.utils.security_utils import get_auth_employee


class _ContractSchema(ResourceSchema):
    supplier_id = colander.SchemaNode(
        SelectInteger(Supplier),
    )
    num = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(min=2, max=32)
    )
    date = colander.SchemaNode(
        Date(),
    )
    status = colander.SchemaNode(
        colander.String(),
    )
    descr = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=255),
        missing=u''
    )
    commission_id = colander.SchemaNode(
        colander.Set(),
        missing=[],
    )

    def deserialize(self, cstruct):
        if (
            'commission_id' in cstruct
            and not isinstance(cstruct.get('commission_id'), list)
        ):
            val = cstruct['commission_id']
            cstruct['commission_id'] = list()
            cstruct['commission_id'].append(val)
        return super(_ContractSchema, self).deserialize(cstruct)


class ContractForm(BaseForm):
    _schema = _ContractSchema

    def submit(self, contract=None):
        if not contract:
            contract = Contract(
                resource=ContractsResource.create_resource(
                    get_auth_employee(self.request)
                )
            )
        else:
            contract.commissions = []
            contract.resource.notes = []
            contract.resource.tasks = []
        contract.supplier = Supplier.get(self._controls.get('supplier_id'))
        contract.num = self._controls.get('num')
        contract.date = self._controls.get('date')
        contract.descr = self._controls.get('descr')
        contract.status = self._controls.get('status')
        for id in self._controls.get('commission_id'):
            commission = Commission.get(id)
            contract.commissions.append(commission)
        for id in self._controls.get('note_id'):
            note = Note.get(id)
            contract.resource.notes.append(note)
        for id in self._controls.get('task_id'):
            task = Task.get(id)
            contract.resource.tasks.append(task)
        return contract


class ContractSearchForm(BaseSearchForm):
    _qb = ContractsQueryBuilder


class ContractAssignForm(BaseAssignForm):
    def submit(self, ids):
        for id in ids:
            contract = Contract.get(id)
            contract.resource.maintainer_id = self._controls.get(
                'maintainer_id'
            )
