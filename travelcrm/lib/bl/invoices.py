# -*coding: utf-8-*-

from sqlalchemy import func
from sqlalchemy.orm import aliased

from ...lib.utils.resources_utils import get_resource_class
from ...lib.utils.sql_utils import build_union_query
from ...lib.utils.common_utils import money_cast
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
from ...models.subaccount import Subaccount
from ...models.transfer import Transfer
from ...models.account_item import AccountItem


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
            func.sum(subq.c.sum)
        )
        .group_by(subq.c.account_item_id)
    )


def query_invoice_payments_transfers(invoice_id):
    account_from = aliased(Account)
    account_to = aliased(Account)
    subaccount_from = aliased(Subaccount)
    subaccount_to = aliased(Subaccount)
    return (
        DBSession.query(
            Transfer.id,
            Transfer.sum,
            Transfer.date,
            AccountItem.name.label('account_item'),
            Currency.iso_code,
            func.coalesce(
                account_from.name,
                subaccount_from.name
            ).label('from'),
            func.coalesce(
                account_to.name,
                subaccount_to.name
            ).label('to')
        )
        .join(Income, Transfer.income)
        .join(AccountItem, Transfer.account_item)
        .join(Invoice, Income.invoice)
        .join(Account, Invoice.account)
        .join(Currency, Account.currency)
        .outerjoin(account_from, Transfer.account_from)
        .outerjoin(account_to, Transfer.account_to)
        .outerjoin(subaccount_from, Transfer.subaccount_from)
        .outerjoin(subaccount_to, Transfer.subaccount_to)
        .filter(Invoice.id == invoice_id)
        .order_by(Transfer.date, Transfer.id)
    )


def get_invoice_payments_transfers_balance(invoice_id):
    invoice = Invoice.get(invoice_id)
    sum_expr = func.coalesce(func.sum(Transfer.sum), 0)
    invoice_transfers = (
        query_invoice_payments_transfers(invoice.id)
        .with_entities(Transfer.id)
    )
    from_transfers_query = (
        query_account_from_transfers(invoice.account_id)
        .with_entities(sum_expr)
        .filter(Transfer.id.in_(invoice_transfers))
    )
    to_transfers_query = (
        query_account_from_transfers(invoice.account_id)
        .with_entities(sum_expr)
        .filter(Transfer.id.in_(invoice_transfers))
    )
    return money_cast(
        to_transfers_query.scalar() 
        - from_transfers_query.scalar()
    )
