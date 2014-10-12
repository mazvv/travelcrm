# -*coding: utf-8-*-
from collections import Iterable

from sqlalchemy.sql import case

from . import ResourcesQueryBuilder

from ...models import DBSession
from ...models.resource import Resource
from ...models.posting import Posting
from ...models.account import Account
from ...models.account_item import AccountItem
from ...models.currency import Currency


class PostingsQueryBuilder(ResourcesQueryBuilder):
    _subq_account_from = (
        DBSession.query(
            Account.id,
            Account.name.label('account_name'),
            Currency.iso_code.label('currency'),
        )
        .join(Currency, Account.currency)
        .subquery()
    )
    _subq_account_to = (
        DBSession.query(
            Account.id,
            Account.name.label('account_name'),
            Currency.iso_code.label('currency'),
        )
        .join(Currency, Account.currency)
        .subquery()
    )

    _fields = {
        'id': Posting.id,
        '_id': Posting.id,
        'date': Posting.date,
        'account_from': _subq_account_from.c.account_name,
        'account_to': _subq_account_to.c.account_name,
        'account_item': AccountItem.name,
        'sum': Posting.sum,
        'currency': case(
            [(
                _subq_account_from.c.currency != None,
                _subq_account_from.c.currency
            )],
            else_=_subq_account_to.c.currency,
        )
    }
    _simple_search_fields = [
        AccountItem.name,
        _subq_account_from.c.account_name,
        _subq_account_to.c.account_name,
    ]

    def __init__(self, context):
        super(PostingsQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = (
            self.query
            .join(Posting, Resource.posting)
            .join(AccountItem, Posting.account_item)
            .outerjoin(self._subq_account_from, Posting.account_from)
            .outerjoin(self._subq_account_to, Posting.account_to)
        )
        self.query = self.query.add_columns(*fields)

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Posting.id.in_(id))
