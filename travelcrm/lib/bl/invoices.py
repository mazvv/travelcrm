# -*coding: utf-8-*-

from sqlalchemy import func

from ...lib.utils.resources_utils import get_resource_class
from ...lib.utils.sql_utils import build_union_query
from ...lib.bl.factories import get_invoices_factories_resources_types
from ...lib.bl.cashflows import (
    query_account_from_cashflows, 
    query_account_to_cashflows,
)
from ...models import DBSession
from ...models.invoice import Invoice
from ...models.resource import Resource
from ...models.income import Income
from ...models.currency import Currency
from ...models.account import Account
from ...models.cashflow import Cashflow


def query_resource_data():
    factories = get_invoices_factories_resources_types()
    queries = [factory.query_list() for factory in factories]
    return build_union_query(queries)


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
            func.sum(Cashflow.sum).label('sum'),
            Currency.iso_code,
            Cashflow.date,
        )
        .join(Income, Cashflow.income)
        .join(Invoice, Income.invoice)
        .join(Account, Invoice.account)
        .join(Currency, Account.currency)
        .filter(
            Invoice.id == invoice_id,
            Cashflow.account_from_id == None,
            Cashflow.subaccount_from_id == None,
            Cashflow.account_to_id == None
        )
        .group_by(Income.id, Currency.iso_code, Cashflow.date)
    )


def query_invoice_payments_accounts_items_grouped(invoice_id):
    invoice = Invoice.get(invoice_id)
    from_cashflows_query = (
        query_account_from_cashflows(invoice.account_id)
        .with_entities(
            Cashflow.account_item_id.label('account_item_id'), 
            Cashflow.sum.label('sum'),
        )
        .join(Income, Cashflow.income)
        .filter(Income.invoice_id == invoice_id)
    )
    to_cashflows_query = (
        query_account_to_cashflows(invoice.account_id)
        .with_entities(
            Cashflow.account_item_id.label('account_item_id'), 
            Cashflow.sum.label('sum'),
        )
        .join(Income, Cashflow.income)
        .filter(Income.invoice_id == invoice_id)
    )
    subq = (
        build_union_query([from_cashflows_query, to_cashflows_query])
        .subquery()
    )
    return (
        DBSession.query(
            subq.c.account_item_id,
            func.sum(subq.c.sum).label('sum')
        )
        .group_by(subq.c.account_item_id)
    )
