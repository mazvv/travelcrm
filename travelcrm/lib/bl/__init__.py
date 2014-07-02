# -*-coding: utf-8-*-

from decimal import Decimal
from abc import ABCMeta

from ...models.invoice import Invoice
from ...models.fin_transaction import FinTransaction
from ...lib.bl.invoices import (
    get_bound_resource_by_invoice_id,
    query_invoice_payments_accounts_items_grouped
)
from ...lib.bl.currencies_rates import query_convert_rates


class InvoiceFactory(object):
    __metaclass__ = ABCMeta

    @classmethod
    def bind_invoice(cls, resource_id, invoice):
        raise NotImplemented()

    @classmethod
    def get_invoice(cls, resource_id):
        raise NotImplemented()

    @classmethod
    def get_base_sum(cls, resource_id):
        raise NotImplemented()

    @classmethod
    def get_sum_by_resource_id(cls, resource_id, currency_id, date):
        base_sum = cls.get_base_sum(resource_id)
        query_rate_converter = query_convert_rates(
            currency_id, date
        )
        rate = query_rate_converter.scalar() or 1
        invoice_sum = base_sum / rate
        return Decimal(invoice_sum).quantize(Decimal('.01'))

    @classmethod
    def get_sum_by_invoice_id(cls, invoice_id):
        invoice = Invoice.get(invoice_id)
        resource = get_bound_resource_by_invoice_id(invoice.id)
        return cls.get_sum_by_resource_id(
            resource.id, invoice.account.currency_id, invoice.date
        )

    @classmethod
    def query_list(cls):
        raise NotImplemented()

    @classmethod
    def make_payment(cls, invoice_id, date, sum):
        invoice = Invoice.get(invoice_id)
        currency = invoice.account.currency
        resource = get_bound_resource_by_invoice_id(invoice.id)
        transacts = []
        payments_query = (
            query_invoice_payments_accounts_items_grouped(invoice.id)
        )
        payments = {item.account_item_id: item.sum for item in payments_query}
        accounts_items_info = cls.accounts_items_info(
            resource.id, currency.id
        )
        for account_item in accounts_items_info:
            account_item_payments = payments.get(account_item.id, 0)
            debt = account_item.price - account_item_payments
            if debt <= sum:
                sum_to_pay = debt
            else:
                sum_to_pay = sum
            transact = FinTransaction(
                account_item_id=account_item.id,
                date=date,
                sum=sum_to_pay
            )
            sum -= sum_to_pay
            transacts.append(transact)
            if sum <= 0:
                break
        return transacts

    @classmethod
    def services_info(cls, resource_id, currency_id=None):
        raise NotImplemented()

    @classmethod
    def accounts_items_info(cls, resource_id, currency_id=None):
        raise NotImplemented()
