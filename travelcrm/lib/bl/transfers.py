# -*coding: utf-8-*-

from sqlalchemy import func, or_

from ...models import DBSession
from ...models.subaccount import Subaccount
from ...models.transfer import Transfer

from ...lib.utils.common_utils import money_cast


def _query_account_subaccounts(account_id):
    assert isinstance(account_id, int)
    return (
        DBSession.query(Subaccount.id)
        .filter(Subaccount.account_id == account_id)
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
    