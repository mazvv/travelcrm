# -*coding: utf-8-*-

from datetime import datetime, date
from decimal import Decimal

from ...models.transfer import Transfer
from ...models.outgoing import Outgoing
from ...models.account import Account
from ...models.subaccount import Subaccount
from ...lib.bl.transfers import get_subaccount_balance


def make_payment(d, account_id, subaccount_id, account_item_id, sum):
    """outgoing transfers creator
    """
    assert isinstance(d, (datetime, date)), \
        u'Datetime or Date instance expected'
    assert isinstance(sum, Decimal), u'Decimal expected'
    transfers = []
    account = Account.get(account_id)
    subaccount = Subaccount.get(subaccount_id)

    if subaccount.account_id == account.id:
        subaccount_balance = get_subaccount_balance(
            subaccount_id, date_to=d
        )
        if subaccount_balance:
            sum_to_transfer = (
                subaccount_balance
                if subaccount_balance <= sum
                else (subaccount_balance - sum)
            )
            sum -= sum_to_transfer
            transfers.append(
                Transfer(
                    subaccount_from_id=subaccount.id,
                    account_item_id=account_item_id,
                    sum=sum_to_transfer,
                    date=d,
                )
            )
    if sum:
        transfer_from_account = Transfer(
            account_from_id=account.id,
            subaccount_to_id=subaccount.id,
            account_item_id=account_item_id,
            sum=sum,
            date=d
        )
        transfer_from_subaccount = Transfer(
            subaccount_from_id=subaccount.id,
            account_item_id=account_item_id,
            sum=sum,
            date=d,
        )
        transfers.extend(
            [transfer_from_account, transfer_from_subaccount]
        )
    return transfers
