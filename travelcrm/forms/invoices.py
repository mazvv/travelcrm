# -*-coding: utf-8 -*-

from datetime import timedelta

import colander

from . import (
    SelectInteger,
    Date,
    ResourceSchema,
    ResourceSearchSchema,
    BaseForm,
    BaseSearchForm,
    BaseAssignForm,
)
from ..resources.invoices import InvoicesResource
from ..models import DBSession
from ..models.invoice import Invoice
from ..models.note import Note
from ..models.task import Task
from ..models.account import Account
from ..models.invoice_item import InvoiceItem
from ..models.order import Order
from ..lib.qb.invoices import InvoicesQueryBuilder
from ..lib.bl.orders import get_order_price
from ..lib.bl.orders_items import (
    get_discount, get_price, get_calculation_price
)
from ..lib.bl.vats import get_vat, calc_vat
from ..lib.utils.common_utils import parse_date
from ..lib.utils.common_utils import translate as _
from ..lib.utils.resources_utils import get_resource_type_by_resource
from ..lib.utils.security_utils import get_auth_employee


@colander.deferred
def valid_until_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        date = parse_date(request.params.get('date'))
        if date > value:
            raise colander.Invalid(
                node,
                _(u'Active until date must be more than invoice date'),
            )
    return colander.All(validator,)


@colander.deferred
def order_id_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        invoice = (
            DBSession.query(Invoice)
            .filter(Invoice.order_id == value)
            .first()
        )
        if (
            invoice
            and str(invoice.id) != request.params.get('id')
        ):
            raise colander.Invalid(
                node,
                _(u'Invoice for this order already exists'),
            )
        order = Order.get(value)
        for order_item in order.orders_items:
            if not order_item.calculation and order_item.is_success():
                raise colander.Invalid(
                    node,
                    _(u'Some order items has no calculations'),
                )
    return colander.All(validator,)


class _InvoiceSchema(ResourceSchema):
    order_id = colander.SchemaNode(
        SelectInteger(Order),
        validator=order_id_validator
    )
    account_id = colander.SchemaNode(
        SelectInteger(Account),
    )
    date = colander.SchemaNode(
        Date(),
    )
    active_until = colander.SchemaNode(
        Date(),
        validator=valid_until_validator
    )
    descr = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=255),
        missing=None
    )


class _InvoiceSearchSchema(ResourceSearchSchema):
    currency_id = colander.SchemaNode(
        colander.Integer(),
        missing=None,
    )
    sum_from = colander.SchemaNode(
        colander.Money(),
        missing=None,
    )
    sum_to = colander.SchemaNode(
        colander.Money(),
        missing=None,
    )
    payment_from = colander.SchemaNode(
        colander.Money(),
        missing=None,
    )
    payment_to = colander.SchemaNode(
        colander.Money(),
        missing=None,
    )
    date_from = colander.SchemaNode(
        Date(),
        missing=None,
    )
    date_to = colander.SchemaNode(
        Date(),
        missing=None,
    )


class InvoiceForm(BaseForm):
    _schema = _InvoiceSchema

    def submit(self, invoice=None):
        if not invoice:
            invoice = Invoice(
                resource=InvoicesResource.create_resource(
                    get_auth_employee(self.request)
                )
            )
        else:
            invoice.invoices_items = []
            invoice.resource.notes = []
            invoice.resource.tasks = []
        invoice.order_id = self._controls.get('order_id')
        invoice.account_id = self._controls.get('account_id')
        invoice.date = self._controls.get('date')
        invoice.active_until = self._controls.get('active_until')
        invoice.descr = self._controls.get('descr')
        self._generate_invoices_items(invoice)

        for id in self._controls.get('note_id'):
            note = Note.get(id)
            invoice.resource.notes.append(note)
        for id in self._controls.get('task_id'):
            task = Task.get(id)
            invoice.resource.tasks.append(task)
        return invoice

    def _generate_invoices_items(self, invoice):
        order = Order.get(self._controls.get('order_id'))
        account = Account.get(self._controls.get('account_id'))
        items = []
        for order_item in order.orders_items:
            if not order_item.is_success():
                continue 
            invoice_item = (
                DBSession.query(InvoiceItem)
                .filter(InvoiceItem.order_item_id == order_item.id)
                .first()
            )
            if not invoice_item:
                invoice_item = InvoiceItem(
                    order_item=order_item,
                )
            invoice_item.invoice = invoice                
            invoice_item.price = get_price(
                order_item, self._controls.get('date'), account.currency_id
            )
            invoice_item.discount = get_discount(
                order_item, self._controls.get('date'), account.currency_id
            )
            vat = get_vat(
                invoice.account_id, order_item.service_id, invoice.date
            )
            if vat:
                vatable_price = invoice_item.final_price
                if not vat.is_full():
                    vatable_price -= get_calculation_price(
                        order_item,
                        self._controls.get('date'),
                        account.currency_id
                    )
                invoice_item.vat = calc_vat(vat.id, vatable_price)
            invoice_item.descr = order_item.service.display_text
        return items


class InvoiceSearchForm(BaseSearchForm):
    _qb = InvoicesQueryBuilder
    _schema = _InvoiceSearchSchema


class _InvoiceSettingsSchema(colander.Schema):
    active_days = colander.SchemaNode(
        colander.Integer(),
    )
    html_template = colander.SchemaNode(
        colander.String(),
    )


class InvoiceSettingsForm(BaseForm):
    _schema = _InvoiceSettingsSchema

    def submit(self):
        context = InvoicesResource(self.request)
        rt = get_resource_type_by_resource(context)
        rt.settings = {
            'active_days': self._controls.get('active_days'),
            'html_template': self._controls.get('html_template'),
        }


class _InvoiceActiveUntilSchema(ResourceSchema):
    date = colander.SchemaNode(
        Date(),
    )


class InvoiceActiveUntilForm(BaseForm):
    _schema = _InvoiceActiveUntilSchema

    def submit(self):
        context = InvoicesResource(self.request)
        rt = get_resource_type_by_resource(context)
        active_days = rt.settings.get('active_days', 0)
        return self._controls.get('date') + timedelta(days=active_days)


class _InvoiceSumSchema(ResourceSchema):
    order_id = colander.SchemaNode(
        colander.Integer(),
    )
    date = colander.SchemaNode(
        Date(),
    )
    account_id = colander.SchemaNode(
        colander.Integer(),
    )


class InvoiceSumForm(BaseForm):
    _schema = _InvoiceSumSchema

    def submit(self):
        account = Account.get(self._controls.get('account_id'))
        return get_order_price(
            self._controls.get('order_id'), 
            self._controls.get('date'), 
            account.currency_id
        )


class InvoiceAssignForm(BaseAssignForm):
    def submit(self, ids):
        for id in ids:
            invoice = Invoice.get(id)
            invoice.resource.maintainer_id = self._controls.get(
                'maintainer_id'
            )
