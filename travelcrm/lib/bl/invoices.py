# -*coding: utf-8-*-

from sqlalchemy import func

from ...lib.utils.resources_utils import get_resource_class
from ...lib.utils.sql_utils import build_union_query
from ...lib.bl.factories import get_invoices_factories_resources_types
from ...lib.utils.common_utils import get_vat as _get_vat
from ...models import DBSession
from ...models.invoice import Invoice
from ...models.resource import Resource
from ...models.income import Income
from ...models.currency import Currency
from ...models.account import Account
from ...models.cashflow import Cashflow


def get_vat(amount):
    vat = _get_vat()
    if not vat:
        return 0
    return amount * vat / (100 + vat)

    
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


def get_invoice_payments_sum(invoice_id):
    invoice = Invoice.get(invoice_id)
    return reduce(lambda s, item: s + item.sum, invoice.incomes, 0)
