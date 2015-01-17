# -*coding: utf-8-*-

from sqlalchemy import func

from ...lib.utils.resources_utils import get_resource_class
from ...lib.utils.sql_utils import build_union_query
from ...lib.bl.factories import get_invoices_factories_resources_types
from ...lib.bl.transfers import (
    query_account_from_transfers, 
    query_account_to_transfers,
)
from ...models import DBSession
from ...models.invoice import Invoice
from ...models.resource import Resource
from ...models.income import Income
from ...models.currency import Currency
from ...models.account import Account
from ...models.transfer import Transfer


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
            func.sum(Transfer.sum).label('sum'),
            Currency.iso_code,
            Transfer.date,
        )
        .join(Income, Transfer.income)
        .join(Invoice, Income.invoice)
        .join(Account, Invoice.account)
        .join(Currency, Account.currency)
        .filter(
            Invoice.id == invoice_id,
            Transfer.account_from_id == None,
            Transfer.subaccount_from_id == None,
            Transfer.account_to_id == None
        )
        .group_by(Income.id, Currency.iso_code, Transfer.date)
    )


def query_invoice_payments_accounts_items_grouped(invoice_id):
    invoice = Invoice.get(invoice_id)
    from_transfers_query = (
        query_account_from_transfers(invoice.account_id)
        .with_entities(
            Transfer.account_item_id.label('account_item_id'), 
            Transfer.sum.label('sum'),
        )
        .join(Income, Transfer.income)
        .filter(Income.invoice_id == invoice_id)
    )
    to_transfers_query = (
        query_account_to_transfers(invoice.account_id)
        .with_entities(
            Transfer.account_item_id.label('account_item_id'), 
            Transfer.sum.label('sum'),
        )
        .join(Income, Transfer.income)
        .filter(Income.invoice_id == invoice_id)
    )
    subq = (
        build_union_query([from_transfers_query, to_transfers_query])
        .subquery()
    )
    return (
        DBSession.query(
            subq.c.account_item_id,
            func.sum(subq.c.sum).label('sum')
        )
        .group_by(subq.c.account_item_id)
    )
