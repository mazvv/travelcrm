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
    def services_info(cls, resource_id, currency_id=None):
        raise NotImplemented()

    @classmethod
    def accounts_items_info(cls, resource_id, currency_id=None):
        raise NotImplemented()


class CalculationFactory(object):
    __metaclass__ = ABCMeta

    @classmethod
    def get_calculations(cls, resource_id):
        raise NotImplemented()

    @classmethod
    def get_services_items(cls, resource_id):
        raise NotImplemented()

    @classmethod
    def get_date(cls, resource_id):
        raise NotImplemented()

    @classmethod
    def query_list(cls):
        raise NotImplemented()
