# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder

from ...models.resource import Resource
from ...models.account import Account
from ...models.subaccount import Subaccount
from ...models.currency import Currency


class SubaccountsQueryBuilder(ResourcesQueryBuilder):

    _fields = {
        'id': Subaccount.id,
        '_id': Subaccount.id,
        'account_name': Account.name,
        'name': Subaccount.name,
        'account_type': Account.account_type,
        'currency': Currency.iso_code,
    }
    _simple_search_fields = [
        Subaccount.name,
        Account.name,
    ]

    def __init__(self, context):
        super(SubaccountsQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = (
            self.query
            .join(Subaccount, Resource.subaccount)
            .join(Account, Subaccount.account)
            .join(Currency, Account.currency)
        )
        self.query = self.query.add_columns(*fields)

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Subaccount.id.in_(id))
