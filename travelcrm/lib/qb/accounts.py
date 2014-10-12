# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.account import Account
from ...models.currency import Currency


class AccountsQueryBuilder(ResourcesQueryBuilder):

    _fields = {
        'id': Account.id,
        '_id': Account.id,
        'name': Account.name,
        'account_type': Account.account_type,
        'display_text': Account.display_text,
        'descr': Account.descr,
        'currency': Currency.iso_code,
    }
    _simple_search_fields = [
        Account.name,
        Currency.iso_code,
    ]

    def __init__(self, context):
        super(AccountsQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = (
            self.query
            .join(Account, Resource.account)
            .join(Currency, Account.currency)
        )
        self.query = self.query.add_columns(*fields)

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Account.id.in_(id))
