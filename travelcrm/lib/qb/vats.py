# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.vat import Vat
from ...models.account import Account
from ...models.service import Service


class VatsQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(VatsQueryBuilder, self).__init__(context)
        self._fields = {
            'id': Vat.id,
            '_id': Vat.id,
            'date': Vat.date,
            'service': Service.name,
            'vat': Vat.vat,
            'account': Account.name,
            'calc_method': Vat.calc_method,
        }
        self._simple_search_fields = [
            Service.name,
            Account.name,
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = (
            self.query.join(Vat, Resource.vat)
            .join(Service, Vat.service)
            .join(Account, Vat.account)
        )
        super(VatsQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Vat.id.in_(id))
