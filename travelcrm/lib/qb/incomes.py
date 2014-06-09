# -*coding: utf-8-*-
from collections import Iterable

from sqlalchemy import func

from . import ResourcesQueryBuilder
from ...models import DBSession
from ...models.resource import Resource
from ...models.income import Income
from ...models.invoice import Invoice
from ...models.account import Account
from ...models.currency import Currency
from ...models.fin_transaction import FinTransaction


class IncomesQueryBuilder(ResourcesQueryBuilder):

    _sum_subq = (
        DBSession.query(
            func.sum(FinTransaction.sum).label('sum'), Income.id
        )
        .join(Income, FinTransaction.income)
        .group_by(Income.id)
        .subquery()
    )

    _fields = {
        'id': Income.id,
        '_id': Income.id,
        'invoice_id': Income.invoice_id,
        'currency': Currency.iso_code,
        'sum': _sum_subq.c.sum,
        'account_name': Account.name,
        'account_type': Account.account_type
    }
    _simple_search_fields = [
        Income.id,
        Account.name,
        Account.account_type,
        Currency.iso_code
    ]

    def __init__(self, context):
        super(IncomesQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = (
            self.query
            .join(Income, Resource.income)
            .join(Invoice, Income.invoice)
            .join(Account, Invoice.account)
            .join(Currency, Account.currency)
            .join(self._sum_subq, self._sum_subq.c.id == Income.id)
        )
        self.query = self.query.add_columns(*fields)

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Income.id.in_(id))
