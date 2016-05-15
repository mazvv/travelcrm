# -*-coding: utf-8 -*-

import colander

from . import(
    ResourceSchema, 
    BaseForm,
    BaseSearchForm,
    BaseAssignForm,
)
from ..resources.banks import BanksResource
from ..models.bank import Bank
from ..models.address import Address
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.banks import BanksQueryBuilder
from ..lib.utils.common_utils import translate as _
from ..lib.utils.security_utils import get_auth_employee


@colander.deferred
def name_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        bank = Bank.by_name(value)
        if (
            bank
            and str(bank.id) != request.params.get('id')
        ):
            raise colander.Invalid(
                node,
                _(u'Bank with the same name exists'),
            )
    return colander.All(colander.Length(max=255), validator,)


class _BankSchema(ResourceSchema):
    name = colander.SchemaNode(
        colander.String(),
        validator=name_validator,
    )
    address_id = colander.SchemaNode(
        colander.Set(),
        missing=[],
    )

    def deserialize(self, cstruct):
        if (
            'address_id' in cstruct
            and not isinstance(cstruct.get('address_id'), list)
        ):
            val = cstruct['address_id']
            cstruct['address_id'] = list()
            cstruct['address_id'].append(val)
        return super(_BankSchema, self).deserialize(cstruct)


class BankForm(BaseForm):
    _schema = _BankSchema

    def submit(self, bank=None):
        if not bank:
            bank = Bank(
                resource=BanksResource.create_resource(
                    get_auth_employee(self.request)
                )
            )
        else:
            bank.addresses = []
            bank.resource.notes = []
            bank.resource.tasks = []
        bank.name = self._controls.get('name')
        for id in self._controls.get('address_id'):
            address = Address.get(id)
            bank.addresses.append(address)
        for id in self._controls.get('note_id'):
            note = Note.get(id)
            bank.resource.notes.append(note)
        for id in self._controls.get('task_id'):
            task = Task.get(id)
            bank.resource.tasks.append(task)
        return bank


class BankSearchForm(BaseSearchForm):
    _qb = BanksQueryBuilder


class BankAssignForm(BaseAssignForm):
    def submit(self, ids):
        for id in ids:
            bank = Bank.get(id)
            bank.resource.maintainer_id = self._controls.get(
                'maintainer_id'
            )
