# -*-coding: utf-8 -*-

import colander

from . import(
    Date,
    ResourceSchema, 
    BaseForm,
    BaseSearchForm,
)
from ..resources.contract import ContractResource
from ..models.contract import Contract
from ..models.commission import Commission
from ..lib.qb.contract import ContractQueryBuilder


class _ContractSchema(ResourceSchema):
    num = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(min=2, max=32)
    )
    date = colander.SchemaNode(
        Date(),
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


class ContractForm(BaseForm):
    _schema = _ContractSchema

    def submit(self, contract=None):
        context = ContractResource(self.request)
        if not contract:
            contract = Contract(
                resource=context.create_resource()
            )
        else:
            contract.commissions = []
        contract.num = self._controls.get('num')
        contract.date = self._controls.get('date')
        contract.descr = self._controls.get('descr')
        for id in self._controls.get('contract_id'):
            commission = Commission.get(id)
            contract.commissions.append(commission)
        return contract


class ContractSearchForm(BaseSearchForm):
    _qb = ContractQueryBuilder
