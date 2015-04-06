# -*-coding: utf-8 -*-

import colander

from . import(
    ResourceSchema, 
    BaseForm,
    BaseSearchForm,
)
from ..resources.account import AccountResource
from ..models.account import Account
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.account import AccountQueryBuilder


@colander.deferred
def name_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        account = Account.by_name(value)
        if (
            account
            and str(account.id) != request.params.get('id')
        ):
            raise colander.Invalid(
                node,
                _(u'Account with the same name exists'),
            )
    return colander.All(colander.Length(max=255), validator,)


class _AccountSchema(ResourceSchema):
    currency_id = colander.SchemaNode(
        colander.Integer(),
    )
    name = colander.SchemaNode(
        colander.String(),
        validator=name_validator
    )
    account_type = colander.SchemaNode(
        colander.String(),
        validator=colander.OneOf(map(lambda x: x[0], Account.ACCOUNTS_TYPES))
    )
    display_text = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=255)
    )
    descr = colander.SchemaNode(
        colander.String(),
        missing=None,
        validator=colander.Length(max=255)
    )


class AccountForm(BaseForm):
    _schema = _AccountSchema

    def submit(self, account=None):
        context = AccountResource(self.request)
        if not account:
            account = Account(
                resource=context.create_resource()
            )
        else:
            account.resource.notes = []
            account.resource.tasks = []
        account.name = self._controls.get('name')
        account.currency_id = self._controls.get('currency_id')
        account.account_type = self._controls.get('account_type')
        account.display_text = self._controls.get('display_text')
        account.descr = self._controls.get('descr')
        for id in self._controls.get('note_id'):
            note = Note.get(id)
            account.resource.notes.append(note)
        for id in self._controls.get('task_id'):
            task = Task.get(id)
            account.resource.tasks.append(task)
        return account


class AccountSearchForm(BaseSearchForm):
    _qb = AccountQueryBuilder
