# -*coding: utf-8-*-

from ...models.invoice import Invoice
from ...models.transfer import Transfer
from ...models.subaccount import Subaccount

from ...lib.bl.invoices import (
    get_bound_resource_by_invoice_id,
    query_invoice_payments_accounts_items_grouped,
    get_factory_by_invoice_id,
)
from ...lib.bl.subaccounts import get_subaccount_by_source_resource_id
from ...lib.utils.resources_utils import get_resource_class


def make_payment(context, invoice_id, date, sum):
     invoice = Invoice.get(invoice_id)
     currency = invoice.account.currency
     resource = get_bound_resource_by_invoice_id(invoice.id)
     transfers = []
     payments_query = (
         query_invoice_payments_accounts_items_grouped(invoice.id)
     )
     payments = {item.account_item_id: item.sum for item in payments_query}
     invoice_factory = get_factory_by_invoice_id(invoice_id)
     accounts_items_info = invoice_factory.accounts_items_info(
         resource.id, currency.id
     )
     customer_resource = invoice_factory.get_customer_resource(resource.id)
     customer_resource_cls = get_resource_class(
         customer_resource.resource_type.name
     )
     subaccount = get_subaccount_by_source_resource_id(
         customer_resource.id, invoice.account_id
     )
     if not subaccount:
         name = "%s | rid: %s" % (invoice.account.name, customer_resource.id)
         subaccount = Subaccount(
             name=name,
             account_id=invoice.account_id,
             resource=context.create_resource()
         )
         subaccount_factory = customer_resource_cls.get_subaccount_factory()
         subaccount_factory.bind_subaccount(
             customer_resource.id, subaccount
         )
     settings = context.get_settings()
     transfers.append(
         Transfer(
             sum=sum,
             date=date,
             subaccount_to=subaccount,
             account_item_id=settings.get('account_item_id')
         )
     )
     for account_item in accounts_items_info:
         account_item_payments = payments.get(account_item.id, 0)
         debt = account_item.price - account_item_payments
         if debt <= sum:
             sum_to_pay = debt
         else:
             sum_to_pay = sum
         transfers.append(
             Transfer(
                 sum=sum_to_pay,
                 date=date,
                 subaccount_from=subaccount,
                 account_to_id=invoice.account_id,
                 account_item_id=account_item.id
             )
         )
         sum -= sum_to_pay
         if sum <= 0:
             break
     return transfers
