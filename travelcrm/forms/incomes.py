# -*-coding: utf-8 -*-

import colander

from . import(
    SelectInteger,
    Date,
    ResourceSchema, 
    BaseForm,
    BaseSearchForm,
    ResourceSearchSchema,
    BaseAssignForm,
)
from ..resources.incomes import IncomesResource
from ..models.income import Income
from ..models.invoice import Invoice
from ..models.account_item import AccountItem
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.incomes import IncomesQueryBuilder
from ..lib.bl.incomes import make_payment
from ..lib.bl.subaccounts import get_company_subaccount
from ..lib.utils.common_utils import translate as _
from ..lib.utils.security_utils import get_auth_employee


@colander.deferred
def account_item_validator(node, kw):

    def validator(node, value):
        account_item = AccountItem.get(value)
        if account_item.is_type_expenses():
            raise colander.Invalid(
                node,
                _(u'Only revenue account item allowed'),
            )
    return validator


@colander.deferred
def invoice_validator(node, kw):

    def validator(node, value):
        invoice = Invoice.get(value)
        company_subaccount = get_company_subaccount(invoice.account.id)
        if not company_subaccount:
            raise colander.Invalid(
                node,
                _(u'Create company subaccount for account from invoice'),
            )
    return validator


class _IncomeSchema(ResourceSchema):
    invoice_id = colander.SchemaNode(
        SelectInteger(Invoice),
        validator=invoice_validator
    )
    account_item_id = colander.SchemaNode(
        SelectInteger(AccountItem),
        validator=account_item_validator
    )
    date = colander.SchemaNode(
        Date(),
    )
    sum = colander.SchemaNode(
        colander.Money(),
        validator=colander.Range(min=0)
    )
    descr = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=255),
        missing=None
    )


class _IncomeSearchSchema(ResourceSearchSchema):
    invoice_id = colander.SchemaNode(
        colander.Integer(),
        missing=None
    )
    account_id = colander.SchemaNode(
        colander.Integer(),
        missing=None
    )
    currency_id = colander.SchemaNode(
        colander.Integer(),
        missing=None,
    )
    payment_from = colander.SchemaNode(
        Date(),
        missing=None
    )
    payment_to = colander.SchemaNode(
        Date(),
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


class IncomeForm(BaseForm):
    _schema = _IncomeSchema

    def submit(self, income=None):
        if not income:
            income = Income(
                resource=IncomesResource.create_resource(
                    get_auth_employee(self.request)
                )
            )
        else:
            income.rollback()
            income.resource.notes = []
            income.resource.tasks = []
        income.account_item_id = self._controls.get('account_item_id')
        income.invoice_id = self._controls.get('invoice_id')
        income.date = self._controls.get('date')
        income.sum = self._controls.get('sum')
        income.descr = self._controls.get('descr')
        income.cashflows = make_payment(self.request, income)
        for id in self._controls.get('note_id'):
            note = Note.get(id)
            income.resource.notes.append(note)
        for id in self._controls.get('task_id'):
            task = Task.get(id)
            income.resource.tasks.append(task)
        return income


class IncomeSearchForm(BaseSearchForm):
    _qb = IncomesQueryBuilder
    _schema = _IncomeSearchSchema


class IncomeAssignForm(BaseAssignForm):
    def submit(self, ids):
        for id in ids:
            income = Income.get(id)
            income.resource.maintainer_id = self._controls.get(
                'maintainer_id'
            )
