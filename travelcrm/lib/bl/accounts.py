# -*coding: utf-8-*-

from datetime import datetime, date

from sqlalchemy import func

from ...models import DBSession
from ...models.fin_transaction import FinTransaction
from ...models.income import Income
from ...models.invoice import Invoice
from ...models.refund import Refund


def get_account_balance(account_id, date_from, date_to):
    """ get account balance between dates or on particular date
    """
    assert isinstance(account_id, int)
    assert isinstance(date_from, (datetime, date)) or date_from is None
    assert isinstance(date_to, (datetime, date))

    query = (
        DBSession.query(
            func.coalesce(
                func.sum(FinTransaction.sum).label('sum'), 0
            )
        )
        .join(Income, FinTransaction.income)
        .join(Invoice, Income.invoice)
        .filter(
            Invoice.account_id == account_id,
            FinTransaction.date <= date_to,
        )
    )
    if date_from is None:
        query = query.filter(FinTransaction.date <= date_to)

    incomes = query.scalar()

    query = (
        DBSession.query(
            func.coalesce(
                func.sum(FinTransaction.sum).label('sum'), 0
            )
        )
        .join(Refund, FinTransaction.refund)
        .join(Invoice, Refund.invoice)
        .filter(
            Invoice.account_id == account_id,
            FinTransaction.date <= date_to,
        )
    )
    if date_from is None:
        query = query.filter(FinTransaction.date <= date_to)

    outgoings = query.scalar()

    return incomes - outgoings
