# -*-coding: utf-8 -*-

import colander

from . import (
    ResourceSchema, 
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


class _AccountItemSchema(ResourceSchema):
    name = colander.SchemaNode(
        colander.String(),
        validator=name_validator,
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
        account_item.name = self._controls.get('name')
        for id in self._controls.get('note_id'):
            note = Note.get(id)
            account_item.resource.notes.append(note)
        for id in self._controls.get('task_id'):
            task = Task.get(id)
            account_item.resource.tasks.append(task)
        return account_item


class AccountItemSearchForm(BaseSearchForm):
    _qb = AccountItemQueryBuilder
