# -*coding: utf-8-*-

from sqlalchemy import func
from sqlalchemy.orm import aliased

from ...models import DBSession
from ...models.currency import Currency
from ...models.subaccount import Subaccount
from ...models.account import Account
from ...models.account_item import AccountItem
from ...models.cashflow import Cashflow


def _get_balance(
    from_cashflows_query, to_cashflows_query, date_from, date_to
):
    if date_from:
        from_cashflows_query = from_cashflows_query.filter(
            Cashflow.date >= date_from
        )
        to_cashflows_query = to_cashflows_query.filter(
            Cashflow.date >= date_from
        )
    if date_to:
        from_cashflows_query = from_cashflows_query.filter(
            Cashflow.date <= date_to
        )
        to_cashflows_query = to_cashflows_query.filter(
            Cashflow.date <= date_to
        )
    return to_cashflows_query.scalar() - from_cashflows_query.scalar()


def query_account_to_cashflows(account_id):
    assert isinstance(account_id, int)
    return (
        DBSession.query(Cashflow)
        .outerjoin(Subaccount, Cashflow.subaccount_to)
        .filter(Subaccount.account_id == account_id)
    )


def query_account_from_cashflows(account_id):
    assert isinstance(account_id, int)
    return (
        DBSession.query(Cashflow)
        .outerjoin(Subaccount, Cashflow.subaccount_from)
        .filter(Subaccount.account_id == account_id)
    )


def get_account_balance(account_id, date_from=None, date_to=None):
    """ get account balance between dates or on particular date
    """
    assert isinstance(account_id, int)
    sum_expr = func.coalesce(func.sum(Cashflow.sum), 0)
    from_cashflows_query = (
        query_account_from_cashflows(account_id)
        .with_entities(sum_expr)
    )
    to_cashflows_query = (
        query_account_to_cashflows(account_id)
        .with_entities(sum_expr)
    )
    return _get_balance(
        from_cashflows_query,
        to_cashflows_query,
        date_from,
        date_to
    )


def query_subaccount_to_cashflows(subaccount_id):
    assert isinstance(subaccount_id, int)
    return (
        DBSession.query(Cashflow)
        .filter(Cashflow.subaccount_to_id == subaccount_id)
    )
    

def query_subaccount_from_cashflows(subaccount_id):
    assert isinstance(subaccount_id, int)
    return (
        DBSession.query(Cashflow)
        .filter(Cashflow.subaccount_from_id == subaccount_id)
    )


def get_subaccount_balance(subaccount_id, date_from=None, date_to=None):
    """ get subaccount balance between dates or on particular date
    """
    assert isinstance(subaccount_id, int)
    sum_expr = func.coalesce(func.sum(Cashflow.sum), 0)
    from_cashflows_query = (
        query_subaccount_from_cashflows(subaccount_id)
        .with_entities(sum_expr)
    )
    to_cashflows_query = (
        query_subaccount_to_cashflows(subaccount_id)
        .with_entities(sum_expr)
    )
    return _get_balance(
        from_cashflows_query,
        to_cashflows_query,
        date_from,
        date_to
    )


def query_cashflows():
    """get common query for cashflows
    """
    from_account = aliased(Account)
    to_account = aliased(Account)
    from_subaccount = aliased(Subaccount)
    to_subaccount = aliased(Subaccount)
    currency_expr = func.coalesce(
        from_account.currency_id,
        to_account.currency_id,
    )
 
    return (
        DBSession.query(
            Cashflow.id,
            Cashflow.date,
            Cashflow.sum,
            Cashflow.subaccount_from_id,
            Cashflow.subaccount_to_id,
            Cashflow.account_item_id,
            Currency.id.label('currency_id'),
            Currency.iso_code.label('currency'),
            from_account.name.label('account_from'),
            to_account.name.label('account_to'),
            from_subaccount.name.label('subaccount_from'),
            to_subaccount.name.label('subaccount_to'),
            AccountItem.name.label('account_item'),
        )
        .distinct(Cashflow.id)
        .join(AccountItem, Cashflow.account_item)
        .outerjoin(from_subaccount, Cashflow.subaccount_from)
        .outerjoin(to_subaccount, Cashflow.subaccount_to)
        .outerjoin(from_account, from_subaccount.account_id == from_account.id)
        .outerjoin(to_account, to_subaccount.account_id == to_account.id)
        .join(Currency, Currency.id == currency_expr)
    )
