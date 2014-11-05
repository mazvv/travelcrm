# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder

from ...models import DBSession
from ...models.resource import Resource
from ...models.resource_type import ResourceType
from ...models.account import Account
from ...models.subaccount import Subaccount
from ...models.currency import Currency

from ...lib.bl.subaccounts import query_resource_data


class SubaccountsQueryBuilder(ResourcesQueryBuilder):

    _subq_resource_type = (
        DBSession.query(ResourceType.humanize, Resource.id)
        .join(Resource, ResourceType.resources)
        .subquery()
    )
    _subq_resource_data = query_resource_data().subquery()
    _fields = {
        'id': Subaccount.id,
        '_id': Subaccount.id,
        'account': Account.name,
        'name': Subaccount.name,
        'title': _subq_resource_data.c.title,
        'currency': Currency.iso_code,
        'resource_type': _subq_resource_type.c.humanize,
   }
    _simple_search_fields = [
        _subq_resource_data.c.name,
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
            .join(
                self._subq_resource_data,
                self._subq_resource_data.c.subaccount_id
                == Subaccount.id
            )
            .join(
                self._subq_resource_type,
                self._subq_resource_type.c.id
                == self._subq_resource_data.c.resource_id
            )
        )
        self.query = self.query.add_columns(*fields)

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Subaccount.id.in_(id))

    def advanced_search(self, **kwargs):
        super(SubaccountsQueryBuilder, self).advanced_search(**kwargs)
        if 'currency_id' in kwargs:
            self._filter_currency(kwargs.get('currency_id'))

    def _filter_currency(self, currency_id):
        if currency_id:
            self.query = self.query.filter(Currency.id == currency_id)
