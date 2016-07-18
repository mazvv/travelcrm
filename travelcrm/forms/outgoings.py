# -*-coding: utf-8 -*-

from decimal import Decimal

import colander

from . import(
    Date,
    SelectInteger,
    ResourceSchema,
    BaseForm,
    BaseSearchForm,
    ResourceSearchSchema,
    BaseAssignForm,
)
from ..resources.outgoings import OutgoingsResource
from ..models.outgoing import Outgoing
from ..models.subaccount import Subaccount
from ..models.account_item import AccountItem
from ..models.note import Note
from ..models.task import Task
from ..lib.utils.common_utils import parse_datetime
from ..lib.qb.outgoings import OutgoingsQueryBuilder
from ..lib.bl.outgoings import make_payment
from ..lib.bl.subaccounts import get_company_subaccount
from ..lib.bl.cashflows import get_account_balance
from ..lib.utils.common_utils import translate as _
from ..lib.utils.security_utils import get_auth_employee


@colander.deferred
def sum_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        if value <= 0:
            raise colander.Invalid(
                node,
                _(u'Sum must be more then zero'),
            )
        subaccount_id = int(request.params.get('subaccount_id'))
        date = parse_datetime(request.params.get('date'))
        sum = Decimal(request.params.get('sum'))
        subaccount = Subaccount.get(subaccount_id)
        balance = get_account_balance(subaccount.account_id, None, date)
        if balance < sum:
            raise colander.Invalid(
                node,
                _(u'Max sum for payment %s' % balance),
            )
    return validator


@colander.deferred
def subaccount_validator(node, kw):

    def validator(node, value):
        subaccount = Subaccount.get(value)
        company_subaccount = get_company_subaccount(subaccount.account.id)
        if not company_subaccount:
            raise colander.Invalid(
                node,
                _(u'Create company subaccount for this account first'),
            )
    return validator


@colander.deferred
def account_item_validator(node, kw):

    def validator(node, value):
        account_item = AccountItem.get(value)
        if account_item.is_type_revenue():
            raise colander.Invalid(
                node,
                _(u'Only revenue account item allowed'),
            )
    return validator


class _OutgoingSchema(ResourceSchema):
    date = colander.SchemaNode(
        Date(),
    )
    sum = colander.SchemaNode(
        colander.Money(),
        validator=sum_validator,
    )
    account_item_id = colander.SchemaNode(
        SelectInteger(AccountItem),
        validator=account_item_validator,
    )
    subaccount_id = colander.SchemaNode(
        SelectInteger(Subaccount),
        validator=subaccount_validator,
    )
    descr = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=255),
        missing=None
    )


class OutgoingForm(BaseForm):
    _schema = _OutgoingSchema

    def submit(self, outgoing=None):
        if not outgoing:
            outgoing = Outgoing(
                resource=OutgoingsResource.create_resource(
                    get_auth_employee(self.request)
                )
            )
        else:
            outgoing.rollback()
            outgoing.resource.notes = []
            outgoing.resource.tasks = []
        outgoing.account_id = self._controls.get('account_id')
        outgoing.subaccount_id = self._controls.get('subaccount_id')
        outgoing.account_item_id = self._controls.get('account_item_id')
        outgoing.date = self._controls.get('date')
        outgoing.sum = self._controls.get('sum')
        outgoing.descr = self._controls.get('descr')
        outgoing.cashflows = make_payment(outgoing)
        for id in self._controls.get('note_id'):
            note = Note.get(id)
            outgoing.resource.notes.append(note)
        for id in self._controls.get('task_id'):
            task = Task.get(id)
            outgoing.resource.tasks.append(task)
        return outgoing


class _OutgoingSearchSchema(ResourceSearchSchema):
    account_id = colander.SchemaNode(
        colander.Integer(),
        missing=None
    )
    account_item_id = colander.SchemaNode(
        colander.Integer(),
        missing=None
    )
    sum_from = colander.SchemaNode(
        colander.Decimal(),
        missing=None
    )
    sum_to = colander.SchemaNode(
        colander.Decimal(),
        missing=None
    )


class OutgoingSearchForm(BaseSearchForm):
    _qb = OutgoingsQueryBuilder
    _schema = _OutgoingSearchSchema


class OutgoingAssignForm(BaseAssignForm):
    def submit(self, ids):
        for id in ids:
            outgoing = Outgoing.get(id)
            outgoing.resource.maintainer_id = self._controls.get(
                'maintainer_id'
            )
