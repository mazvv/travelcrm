# -*coding: utf-8-*-

from datetime import datetime, date
from decimal import Decimal

from ...models.fin_transaction import FinTransaction


def make_payment(d, account_item_id, sum):
    assert isinstance(account_item_id, int), u'Integer expected'
    assert isinstance(d, (datetime, date)), \
        u'Datetime or Date instance expected'
    assert isinstance(sum, Decimal), u'Decimal expected'
    return [
        FinTransaction(
            account_item_id=account_item_id,
            date=d,
            sum=sum,
            factor=-1,
        ),
    ]
