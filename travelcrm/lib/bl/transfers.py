# -*coding: utf-8-*-

from sqlalchemy import func, or_
from sqlalchemy.orm import aliased

from ...models import DBSession
from ...models.currency import Currency
from ...models.subaccount import Subaccount
from ...models.account import Account
from ...models.account_item import AccountItem
from ...models.transfer import Transfer

from ...lib.utils.common_utils import money_cast


def _query_account_subaccounts(account_id):
    assert isinstance(account_id, int)
    return (
        DBSession.query(Subaccount.id)
        .filter(Subaccount.account_id == account_id)
    )


def _get_balance(
    from_transfers_query, to_transfers_query, date_from, date_to
):
    if date_from:
        from_transfers_query = from_transfers_query.filter(
            Transfer.date >= date_from
        )
        to_transfers_query = to_transfers_query.filter(
            Transfer.date >= date_from
        )
    if date_to:
        from_transfers_query = from_transfers_query.filter(
            Transfer.date <= date_to
        )
        to_transfers_query = to_transfers_query.filter(
            Transfer.date <= date_to
        )
    return money_cast(
        to_transfers_query.scalar() 
        - from_transfers_query.scalar()
    )
    
    
def query_account_to_transfers(account_id):
    assert isinstance(account_id, int)
    return (
        DBSession.query(Transfer)
        .filter(
            or_(
                Transfer.account_to_id == account_id,
                Transfer.subaccount_to_id.in_(
                    _query_account_subaccounts(account_id)
                )
            )
        )
    )
    

def query_account_from_transfers(account_id):
    assert isinstance(account_id, int)
    return (
        DBSession.query(Transfer)
        .filter(
            or_(
                Transfer.account_from_id == account_id,
                Transfer.subaccount_from_id.in_(
                    _query_account_subaccounts(account_id)
                )
            )
        )
    )


def get_account_balance(account_id, date_from=None, date_to=None):
    """ get account balance between dates or on particular date
    """
    assert isinstance(account_id, int)
    sum_expr = func.coalesce(func.sum(Transfer.sum), 0)
    from_transfers_query = (
        query_account_from_transfers(account_id)
        .with_entities(sum_expr)
    )
    to_transfers_query = (
        query_account_to_transfers(account_id)
        .with_entities(sum_expr)
    )
    return _get_balance(
        from_transfers_query,
        to_transfers_query,
        date_from,
        date_to
    )


def query_subaccount_to_transfers(subaccount_id):
    assert isinstance(subaccount_id, int)
    return (
        DBSession.query(Transfer)
        .filter(Transfer.subaccount_to_id == subaccount_id)
    )
    

def query_subaccount_from_transfers(subaccount_id):
    assert isinstance(subaccount_id, int)
    return (
        DBSession.query(Transfer)
        .filter(Transfer.subaccount_from_id == subaccount_id)
    )


def get_subaccount_balance(subaccount_id, date_from=None, date_to=None):
    """ get subaccount balance between dates or on particular date
    """
    assert isinstance(subaccount_id, int)
    sum_expr = func.coalesce(func.sum(Transfer.sum), 0)
    from_transfers_query = (
        query_subaccount_from_transfers(subaccount_id)
        .with_entities(sum_expr)
    )
    to_transfers_query = (
        query_subaccount_to_transfers(subaccount_id)
        .with_entities(sum_expr)
    )
    return _get_balance(
        from_transfers_query,
        to_transfers_query,
        date_from,
        date_to
    )


def query_transfers():
    """get common query for transfers
    """
    from_account = aliased(Account)
    to_account = aliased(Account)
    from_subaccount = aliased(Subaccount)
    to_subaccount = aliased(Subaccount)
    from_subaccount_account = aliased(Account)
    to_subaccount_account = aliased(Account)
    currency_expr = func.coalesce(
        from_account.currency_id,
        to_account.currency_id,
        from_subaccount_account.currency_id,
        to_subaccount_account.currency_id,
    )
 
    return (
        DBSession.query(
            Transfer.id,
            Transfer.date,
            Transfer.sum,
            Transfer.account_from_id,
            Transfer.subaccount_from_id,
            Transfer.account_to_id,
            Transfer.subaccount_to_id,
            Transfer.account_item_id,
            Currency.id.label('currency_id'),
            Currency.iso_code.label('currency'),
            from_account.name.label('account_from'),
            to_account.name.label('account_to'),
            from_subaccount.name.label('subaccount_from'),
            to_subaccount.name.label('subaccount_to'),
            AccountItem.name.label('account_item'),
            from_subaccount.account_id.label('subaccount_from_account_id'),
            to_subaccount.account_id.label('subaccount_to_account_id'),
        )
        .distinct(Transfer.id)
        .join(AccountItem, Transfer.account_item)
        .outerjoin(from_account, Transfer.account_from)
        .outerjoin(to_account, Transfer.account_to)
        .outerjoin(from_subaccount, Transfer.subaccount_from)
        .outerjoin(to_subaccount, Transfer.subaccount_to)
        .outerjoin(
            from_subaccount_account, 
            from_subaccount.account_id == from_subaccount_account.id,
        )
        .outerjoin(
            to_subaccount_account, 
            to_subaccount.account_id == to_subaccount_account.id,
        )
        .join(Currency, Currency.id == currency_expr)
    )
