# -*coding: utf-8-*-

from sqlalchemy import func

from ...models import DBSession
from ...models.account import Account
from ...models.subaccount import Subaccount
from ...models.transfer import Transfer

from ...lib.bl.transfers import query_transfers


def _subq_filter_date(date_from, date_to):
    query = query_transfers()
    if date_from:
        query = query.filter(Transfer.date >= date_from)
    if date_to:
        query = query.filter(Transfer.date <= date_to)
    return query.subquery()


def query_accounts_turnovers(date_from=None, date_to=None):
    subq_transfers = _subq_filter_date(date_from, date_to)
    account_from_expr = func.coalesce(
        subq_transfers.c.account_from_id,
        subq_transfers.c.subaccount_from_account_id,
        0,
    )
    account_to_expr = func.coalesce(
        subq_transfers.c.account_to_id,
        subq_transfers.c.subaccount_to_account_id,
        0,
    )
    query_from = (
        DBSession.query(
            func.sum(subq_transfers.c.sum).label('sum'),
            account_from_expr.label('account_from_id'),
        )
        .group_by(account_from_expr)
        .subquery()
    )
    query_to = (
        DBSession.query(
            func.sum(subq_transfers.c.sum).label('sum'),
            account_to_expr.label('account_to_id'),
        )
        .group_by(account_to_expr)
        .subquery()
    )
    query = (
        DBSession.query(
            Account.id,
            query_from.c.sum.label('sum_from'),
            query_to.c.sum.label('sum_to'),
        )
        .outerjoin(
            query_from, 
            query_from.c.account_from_id == Account.id
        )
        .outerjoin(
            query_to, 
            query_to.c.account_to_id == Account.id,
        )
    )
    return query


def query_subaccounts_turnovers(date_from=None, date_to=None):
    subq_transfers = _subq_filter_date(date_from, date_to)
    query_from = (
        DBSession.query(
            func.sum(subq_transfers.c.sum).label('sum'),
            subq_transfers.c.subaccount_from_id,
        )
        .group_by(subq_transfers.c.subaccount_from_id)
        .subquery()
    )
    query_to = (
        DBSession.query(
            func.sum(subq_transfers.c.sum).label('sum'),
            subq_transfers.c.subaccount_to_id,
        )
        .group_by(subq_transfers.c.subaccount_to_id)
        .subquery()
    )
    query = (
        DBSession.query(
            Subaccount.id,
            query_from.c.sum.label('sum_from'),
            query_to.c.sum.label('sum_to'),
        )
        .outerjoin(
            query_from, 
            query_from.c.subaccount_from_id == Subaccount.id
        )
        .outerjoin(
            query_to, 
            query_to.c.subaccount_to_id == Subaccount.id
        )
    )
    return query
