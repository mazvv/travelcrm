# -*coding: utf-8-*-

from ...models.invoice import Invoice
from ...models.fin_transaction import FinTransaction

from ...lib.bl.invoices import (
    get_bound_resource_by_invoice_id,
    query_invoice_payments_accounts_items_grouped,
    get_factory_by_invoice_id,
)


class IncomePaymentsFactory(object):

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
        invoice_factory = get_factory_by_invoice_id(invoice_id)
        accounts_items_info = invoice_factory.accounts_items_info(
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
