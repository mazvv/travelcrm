# -*-coding: utf-8 -*-

import colander

from . import(
    SelectInteger,
    ResourceSchema, 
    ResourceSearchSchema,
    BaseForm,
    BaseSearchForm,
    BaseAssignForm,
)
from ..resources.subaccounts import SubaccountsResource
from ..models.subaccount import Subaccount
from ..models.account import Account
from ..models.note import Note
from ..models.task import Task
from ..lib.bl.subaccounts import (
    get_subaccounts_types, 
    get_subaccount_by_source_id
)
from ..lib.utils.resources_utils import (
    get_resource_class, 
    get_resource_type_by_resource_cls
)
from ..lib.qb.subaccounts import SubaccountsQueryBuilder
from ..lib.utils.common_utils import translate as _
from ..lib.utils.security_utils import get_auth_employee


@colander.deferred
def name_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        subaccount = Subaccount.by_name(value)
        if (
            subaccount
            and str(subaccount.id) != request.params.get('id')
        ):
            raise colander.Invalid(
                node,
                _(u'Subaccount with the same name exists'),
            )
    return colander.All(colander.Length(max=255), validator,)


def subaccount_type_validator(node, kw):
    return colander.OneOf(
        map(lambda x: x.name, get_subaccounts_types())
    )


@colander.deferred
def source_id_validator(node, kw):
    request = kw.get('request')
    
    def validator(node, value):
        resource_cls = get_resource_class(
            request.params.get('subaccount_type')
        )
        rt = get_resource_type_by_resource_cls(resource_cls)
        account_id = request.params.get('account_id') or 0
        subaccount = get_subaccount_by_source_id(
            value, rt.id, account_id
        )
        if (
            subaccount
            and str(subaccount.id) != request.params.get('id')
        ):
            raise colander.Invalid(
                node,
                _(u'Subaccount for this account already exists'),
            )
        
    return colander.All(validator,)


class _SubaccountSchema(ResourceSchema):
    account_id = colander.SchemaNode(
        SelectInteger(Account),
    )
    subaccount_type = colander.SchemaNode(
        colander.String(),
        validator=subaccount_type_validator
    )
    source_id = colander.SchemaNode(
        colander.Integer(),
        validator=source_id_validator
    )
    name = colander.SchemaNode(
        colander.String(),
        validator=name_validator
    )
    descr = colander.SchemaNode(
        colander.String(),
        missing=None,
        validator=colander.Length(max=255)
    )


class _SubaccountSearchSchema(ResourceSearchSchema):
    account_id = colander.SchemaNode(
        colander.Integer(),
        missing=None
    )


class SubaccountForm(BaseForm):
    _schema = _SubaccountSchema

    def submit(self, subaccount=None):
        if not subaccount:
            subaccount = Subaccount(
                resource=SubaccountsResource.create_resource(
                    get_auth_employee(self.request)
                )
            )
        else:
            subaccount.resource.notes = []
            subaccount.resource.tasks = []
        subaccount.account_id = self._controls.get('account_id')
        subaccount.name = self._controls.get('name')
        subaccount.descr = self._controls.get('descr')

        source_cls = get_resource_class(self._controls.get('subaccount_type'))
        factory = source_cls.get_subaccount_factory()
        source_resource = factory.get_source_resource(
            self._controls.get('source_id')
        )
        
        for id in self._controls.get('note_id'):
            note = Note.get(id)
            subaccount.resource.notes.append(note)
        for id in self._controls.get('task_id'):
            task = Task.get(id)
            subaccount.resource.tasks.append(task)
        return subaccount, factory.bind_subaccount(
            source_resource.id, subaccount
        )


class SubaccountSearchForm(BaseSearchForm):
    _qb = SubaccountsQueryBuilder
    _schema = _SubaccountSearchSchema


class SubaccountAssignForm(BaseAssignForm):
    def submit(self, ids):
        for id in ids:
            subaccount = Subaccount.get(id)
            subaccount.resource.maintainer_id = self._controls.get(
                'maintainer_id'
            )
