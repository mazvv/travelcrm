# -*coding: utf-8-*-

from sqlalchemy import func

from ...lib.utils.resources_utils import get_resource_class
from ...lib.utils.sql_utils import build_union_query
from ...lib.bl.factories import get_invoices_factories_resources_types
from ...models import DBSession
from ...models.invoice import Invoice
from ...models.resource import Resource
from ...models.income import Income
from ...models.currency import Currency
from ...models.account import Account
from ...models.fin_transaction import FinTransaction
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
            func.sum(FinTransaction.sum).label('sum'),
            Currency.iso_code,
            FinTransaction.date,
        )
        .join(Income, FinTransaction.income)
        .join(Invoice, Income.invoice)
        .join(Account, Invoice.account)
        .join(Currency, Account.currency)
        .filter(Invoice.id == invoice_id)
        .group_by(Income.id, Currency.iso_code, FinTransaction.date)
    )


def query_invoice_payments_accounts_items_grouped(invoice_id):
    return (
        DBSession.query(
            func.sum(FinTransaction.sum).label('sum'),
            FinTransaction.account_item_id
        )
        .join(Income, FinTransaction.income)
        .filter(Income.invoice_id == invoice_id)
        .group_by(FinTransaction.account_item_id)
    )


def query_invoice_payments_transactions(invoice_id):
    return (
        DBSession.query(
            FinTransaction.id,
            FinTransaction.sum,
            FinTransaction.account_item_id,
            FinTransaction.date,
            AccountItem.name,
            Currency.iso_code,
        )
        .join(Income, FinTransaction.income)
        .join(AccountItem, FinTransaction.account_item)
        .join(Invoice, Income.invoice)
        .join(Account, Invoice.account)
        .join(Currency, Account.currency)
        .filter(Invoice.id == invoice_id)
        .order_by(FinTransaction.date)
    )
