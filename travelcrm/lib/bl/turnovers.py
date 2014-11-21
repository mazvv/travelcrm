# -*coding: utf-8-*-

from sqlalchemy import func

from ...models import DBSession
from ...models.currency import Currency
from ...models.account import Account

from ...lib.utils.common_utils import money_cast
from ...lib.bl.transfers import query_transfers


def query_turnovers():
    subquery_transfers = query_transfers().subquery()
    account_from_expr = func.coalesce(
        subquery_transfers.c.account_from_id,
        subquery_transfers.c.subaccount_from_account_id,
        0,
    )
    account_to_expr = func.coalesce(
        subquery_transfers.c.account_to_id,
        subquery_transfers.c.subaccount_to_account_id,
        0,
    )
    query_from_transfers = (
        DBSession.query(
            money_cast(func.sum(subquery_transfers.c.sum)).label('sum'),
            account_from_expr.label('account_from_id'),
        )
        .group_by(
            account_from_expr
        )
        .subquery()
    )
    query_to_transfers = (
        DBSession.query(
            money_cast(func.sum(subquery_transfers.c.sum)).label('sum'),
            account_to_expr.label('account_to_id'),
        )
        .group_by(
            account_to_expr
        )
        .subquery()
    )
    query = (
        DBSession.query(
            Account.id,
            query_from_transfers.c.sum.label('sum_from'),
            query_to_transfers.c.sum.label('sum_to'),
        )
        .outerjoin(
            query_from_transfers, 
            query_from_transfers.c.account_from_id == Account.id
        )
        .outerjoin(
            query_to_transfers, 
            query_to_transfers.c.account_to_id == Account.id
        )
    )
    return query
