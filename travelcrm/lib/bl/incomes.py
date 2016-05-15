# -*coding: utf-8-*-

from ...resources.subaccounts import SubaccountsResource
from ...models.income import Income
from ...models.invoice import Invoice
from ...models.cashflow import Cashflow
from ...models.subaccount import Subaccount

from ...lib.bl.subaccounts import (
    get_subaccount_by_source_resource_id,
    get_company_subaccount,
    generate_subaccount_name
)
from ...lib.bl.invoices import get_invoice_payments_sum
from ...lib.utils.resources_utils import get_resource_class
from ...lib.utils.security_utils import get_auth_employee


def make_payment(request, income):
    assert isinstance(income, Income), u'Income obj expected got' % type(income)
    invoice = Invoice.get(income.invoice_id)
    customer = invoice.order.customer
    cashflows = []
    subaccount = get_subaccount_by_source_resource_id(
        customer.resource.id, invoice.account_id
    )
    company_subaccount = get_company_subaccount(invoice.account_id)
    assert company_subaccount, u'Company subaccount does not exists'
    if not subaccount:
        name = generate_subaccount_name(customer.name, invoice.account.id)
        subaccount = Subaccount(
            name=name,
            account_id=invoice.account_id,
            resource=SubaccountsResource.create_resource(
                get_auth_employee(request)
            )
        )
        customer_resource_cls = get_resource_class(
            customer.resource.resource_type.name
        )
        subaccount_factory = customer_resource_cls.get_subaccount_factory()
        subaccount_factory.bind_subaccount(
            customer.resource.id, subaccount
        )
    cashflows.append(
        Cashflow(
            sum=income.sum,
            date=income.date,
            subaccount_to=subaccount,
            account_item_id=income.account_item_id,
            vat=invoice.vat,
        )
    )
    payments_sum = get_invoice_payments_sum(invoice.id)
    if income.id:
        payments_sum -= income.sum
    debt = invoice.final_price - payments_sum
    if debt > 0:
        cashflows.append(
            Cashflow(
                sum=min([debt, income.sum]),
                date=income.date,
                subaccount_from=subaccount,
                subaccount_to=company_subaccount,
#                 account_item_id=income.account_item_id,
            )
        )
    return cashflows
