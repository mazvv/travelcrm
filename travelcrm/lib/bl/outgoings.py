# -*coding: utf-8-*-

from ...models.cashflow import Cashflow
from ...models.outgoing import Outgoing
from ...models.subaccount import Subaccount
from ...lib.bl.subaccounts import get_company_subaccount
from ...lib.bl.cashflows import get_subaccount_balance


def make_payment(outgoing):
    """outgoing cashflows creator
    """
    assert isinstance(outgoing, Outgoing), \
        u'Outgoing obj expected got %s' % type(outgoing)
    subaccount = Subaccount.get(outgoing.subaccount_id)
    company_subaccount = get_company_subaccount(subaccount.account.id)
    assert company_subaccount, u'Company subaccount does not exists'
    subaccount_balance = get_subaccount_balance(subaccount.id)
    cashflows = []
    transfer_amount = outgoing.sum - subaccount_balance
    if outgoing.id:
        transfer_amount -= outgoing.sum
    if transfer_amount > 0:
        cashflows.append(
            Cashflow(
                subaccount_from_id=company_subaccount.id,
                subaccount_to_id=subaccount.id,
                #account_item_id=outgoing.account_item_id,
                sum=transfer_amount,
                date=outgoing.date,
            )
        )
    cashflows.append(
        Cashflow(
            subaccount_from_id=subaccount.id,
            account_item_id=outgoing.account_item_id,
            sum=outgoing.sum,
            date=outgoing.date,
        ),
    )
    return cashflows
