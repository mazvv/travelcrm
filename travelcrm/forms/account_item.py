# -*-coding: utf-8 -*-

import colander

from . import (
    ResourceSchema,
    ResourceSearchSchema,
    BaseForm,
    BaseSearchForm,
)
from ..resources.account_item import AccountItemResource
from ..models.account_item import AccountItem
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.account_item import AccountItemQueryBuilder
from ..lib.utils.common_utils import translate as _


@colander.deferred
def name_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        account_item = AccountItem.by_name(value)
        if (
            account_item
            and str(account_item.id) != request.params.get('id')
        ):
            raise colander.Invalid(
                node,
                _(u'Account Item with the same name exists'),
            )
    return colander.All(colander.Length(max=255), validator,)


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


class _AccountItemSchema(ResourceSchema):
    parent_id = colander.SchemaNode(
        colander.Integer(),
        validator=parent_validator,
        missing=None,
    )
    name = colander.SchemaNode(
        colander.String(),
        validator=name_validator,
    )
    type = colander.SchemaNode(
        colander.String()
    )
    status = colander.SchemaNode(
        colander.String()
    )
    descr = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=128),
        missing=None
    )


class AccountItemForm(BaseForm):
    _schema = _AccountItemSchema

    def submit(self, account_item=None):
        context = AccountItemResource(self.request)
        if not account_item:
            account_item = AccountItem(
                resource=context.create_resource()
            )
        else:
            account_item.resource.notes = []
            account_item.resource.tasks = []
        account_item.parent_id = self._controls.get('parent_id')
        account_item.name = self._controls.get('name')
        account_item.type = self._controls.get('type')
        account_item.status = self._controls.get('status')
        account_item.descr = self._controls.get('descr')
        for id in self._controls.get('note_id'):
            note = Note.get(id)
            account_item.resource.notes.append(note)
        for id in self._controls.get('task_id'):
            task = Task.get(id)
            account_item.resource.tasks.append(task)
        return account_item


class _AccountItemSearchSchema(ResourceSearchSchema):
    with_chain = colander.SchemaNode(
        colander.String(),
        missing=None,
    )
    

class AccountItemSearchForm(BaseSearchForm):
    _schema = _AccountItemSearchSchema
    _qb = AccountItemQueryBuilder

    def _search(self):
        parent_id = self._controls.get('id')
        self.qb.filter_parent_id(
            parent_id,
            with_chain=self._controls.get('with_chain')
        )
        