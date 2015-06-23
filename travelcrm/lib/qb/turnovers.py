# -*coding: utf-8-*-

from sqlalchemy import func, literal, case, or_

from . import ResourcesQueryBuilder

from ...models import DBSession
from ...models.resource import Resource
from ...models.account_item import AccountItem
from ...models.subaccount import Subaccount
from ...models.cashflow import Cashflow
from ...lib.qb.accounts_items import AccountsItemsQueryBuilder


class TurnoversQueryBuilder(
    AccountsItemsQueryBuilder, ResourcesQueryBuilder
):
    _base_fields = {
        'rid': Resource.id.label('rid'),
    }

    def __init__(self, context):
        ResourcesQueryBuilder.__init__(self, context)
        self._cashflows_from_sub = (
            DBSession.query(
                func.sum(Cashflow.sum).label('expenses'),
                Cashflow.account_item_id.label('account_item_id'),
            )
            .join(Subaccount, Cashflow.subaccount_from)
            .group_by(Cashflow.account_item_id)
        )
        self._cashflows_to_sub = (
            DBSession.query(
                func.sum(Cashflow.sum).label('revenue'),
                Cashflow.account_item_id.label('account_item_id'),
            )
            .join(Subaccount, Cashflow.subaccount_to)
            .group_by(Cashflow.account_item_id)
        )
        self._fields = {
            'id': AccountItem.id,
            '_id': AccountItem.id,
            'name': AccountItem.name,
            'text': AccountItem.name,
            'parent_id': AccountItem.parent_id.label('parent_id')
        }
        self.build_query()

    def build_query(self):
        self.build_base_query()
        accounts_items_subquery = (
            DBSession.query(
                AccountItem.parent_id,
                literal(u'closed').label('state')
            )
            .group_by(AccountItem.parent_id)
            .subquery()
        )
        self.query = (
            self.query
            .join(AccountItem, Resource.account_item)
            .outerjoin(
                accounts_items_subquery,
                accounts_items_subquery.c.parent_id == AccountItem.id
            )
        )
        self.update_fields({'state': accounts_items_subquery.c.state})
        super(AccountsItemsQueryBuilder, self).build_query()

    def advanced_search(self, **kwargs):
        super(TurnoversQueryBuilder, self).advanced_search(**kwargs)
        self._filter_account(kwargs.get('account_id'))
        if 'date_from' in kwargs or 'date_to' in kwargs:
            self._filter_date(
                kwargs.get('date_from'), kwargs.get('date_to')
            )
        self._cashflows_from_sub = self._cashflows_from_sub.subquery()
        self._cashflows_to_sub = self._cashflows_to_sub.subquery()
        self.query = (
            self.query
            .outerjoin(
                self._cashflows_from_sub,
                self._cashflows_from_sub.c.account_item_id == AccountItem.id
            )
            .outerjoin(
                self._cashflows_to_sub,
                self._cashflows_to_sub.c.account_item_id == AccountItem.id
            )
        )
        balance_condition = or_(
            self._cashflows_to_sub.c.revenue != None, 
            self._cashflows_from_sub.c.expenses != None
        )
        balance_expression = (
            func.coalesce(self._cashflows_to_sub.c.revenue, 0)
            - func.coalesce(self._cashflows_from_sub.c.expenses, 0)
        )
        balance_case = (balance_condition, balance_expression)
        self.update_fields({
            'expenses': self._cashflows_from_sub.c.expenses,
            'revenue': self._cashflows_to_sub.c.revenue,
            'balance': case([balance_case,], else_=None),            
        })
        ResourcesQueryBuilder.build_query(self)

    def _filter_account(self, account_id):
        self._cashflows_from_sub = self._cashflows_from_sub.filter(
            Subaccount.account_id == account_id
        )
        self._cashflows_to_sub = self._cashflows_to_sub.filter(
            Subaccount.account_id == account_id
        )

    def _filter_date(self, date_from, date_to):
        if date_from:
            self._cashflows_from_sub = self._cashflows_from_sub.filter(
                Cashflow.date >= date_from
            )
            self._cashflows_to_sub = self._cashflows_to_sub.filter(
                Cashflow.date >= date_from
            )
        if date_to:
            self._cashflows_from_sub = self._cashflows_from_sub.filter(
                Cashflow.date <= date_to
            )
            self._cashflows_to_sub = self._cashflows_to_sub.filter(
                Cashflow.date <= date_to
            )
