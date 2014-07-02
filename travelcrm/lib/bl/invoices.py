# -*coding: utf-8-*-
from inspect import isfunction

from sqlalchemy import func

from ...interfaces import IInvoiceFactory

from ...lib.utils.resources_utils import (
    get_resources_types_by_interface,
    get_resource_class
)
from ...lib.utils.common_utils import money_cast
from ...lib.bl.currencies_rates import query_convert_rates

from ...models import DBSession
from ...models.invoice import Invoice
from ...models.resource import Resource
from ...models.income import Income
from ...models.currency import Currency
from ...models.account import Account
from ...models.fin_transaction import FinTransaction


def get_invoices_factories_resources_types():
    factories = []
    for rt in get_resources_types_by_interface(IInvoiceFactory):
        rt_cls = get_resource_class(rt.name)
        assert isfunction(rt_cls.get_invoice_factory), u"Must be static method"
        factories.append(rt_cls.get_invoice_factory())
    return factories


def query_resource_data():
    factories = get_invoices_factories_resources_types()
    res = None
    for i, factory in enumerate(factories):
        if not i:
            res = factory.query_list()
        else:
            res = res.union(factory.query_list())
    return res


def get_bound_resource_by_invoice_id(invoice_id):
    bound_resource = (
        query_resource_data()
        .filter(Invoice.id == invoice_id)
        .first()
    )
    return Resource.get(bound_resource.resource_id)


def get_factory_by_invoice_id(invoice_id):
    resource = get_bound_resource_by_invoice_id(invoice_id)
    source_cls = get_resource_class(resource.resource_type.name)
    factory = source_cls.get_invoice_factory()
    return factory


def query_invoice_payments(invoice_id):
    return (
        DBSession.query(
            func.sum(FinTransaction.sum).label('sum'),
            Currency.iso_code,
            FinTransaction.date,
        )
        .join(Income, FinTransaction.income)
        .join(Invoice, Income.invoice)
        .join(Account, Invoice.account)
        .join(Currency, Account.currency)
        .filter(Invoice.id == invoice_id)
        .group_by(Currency.iso_code, FinTransaction.date)
    )


def query_invoice_payments_accounts_items_grouped(invoice_id):
    return (
        DBSession.query(
            func.sum(FinTransaction.sum).label('sum'),
            FinTransaction.account_item_id
        )
        .join(Income, FinTransaction.income)
        .join(Invoice, Income.invoice)
        .filter(Invoice.id == invoice_id)
        .group_by(FinTransaction.account_item_id)
    )
