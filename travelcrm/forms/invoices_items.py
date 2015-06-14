# -*-coding: utf-8 -*-

import colander

from . import (
    Date,
    ResourceSchema,
    BaseForm,
    BaseSearchForm,
)
from ..models.invoice_item import InvoiceItem
from ..models.order import Order
from ..models.account import Account
from ..lib.qb.invoices_items import InvoicesItemsQueryBuilder
from ..lib.bl.orders_items import get_price, get_discount
from ..lib.bl.invoices import get_vat


class _InvoiceItemSchema(ResourceSchema):
    service_id = colander.SchemaNode(
        colander.Integer(),
    )
    price = colander.SchemaNode(
        colander.Money()
    )
    vat = colander.SchemaNode(
        colander.Money()
    )
    discount = colander.SchemaNode(
        colander.Money(),
    )
    descr = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=255)
    )


class InvoiceItemForm(BaseForm):
    _schema = _InvoiceItemSchema

    def submit(self, invoice_item=None):
        context = InvoicesItemsResource(self.request)
        if not invoice_item:
            invoice_item = InvoiceItem(
                resource=context.create_resource()
            )

        invoice_item.service_id = self._controls.get('service_id')
        invoice_item.price = self._controls.get('price')
        invoice_item.discount = self._controls.get('discount')
        invoice_item.vat = self._controls.get('vat')
        invoice_item.descr = self._controls.get('descr')
        return invoice_item


class InvoiceItemSearchForm(BaseSearchForm):
    _qb = InvoicesItemsQueryBuilder


class _InvoiceItemAddSchema(ResourceSchema):
    date = colander.SchemaNode(
        Date(),
    )
    order_id = colander.SchemaNode(
        colander.Integer()
    )
    account_id = colander.SchemaNode(
        colander.Integer()
    )


class InvoiceItemAddForm(BaseForm):
    _schema = _InvoiceItemAddSchema

    def submit(self):
        context = InvoicesItemsResource(self.request)
        order = Order.get(self._controls.get('order_id'))
        account = Account.get(self._controls.get('account_id'))
        items = []
        for order_item in order.orders_items:
            price = get_price(
                order_item, self._controls.get('date'), account.currency_id
            )
            discount = get_discount(
                order_item, self._controls.get('date'), account.currency_id
            )
            items.append(
                InvoiceItem(
                    service_id=order_item.service_id,
                    price=price,
                    discount=discount,
                    vat=get_vat(price - discount),
                    descr=order_item.service.display_text,
                    resource=context.create_resource(),
                )
            )
        return items
