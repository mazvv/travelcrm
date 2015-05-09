# -*coding: utf-8-*-

from collections import Iterable

from . import ResourcesQueryBuilder

from ...models.resource import Resource
from ...models.contract import Contract


class ContractQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(ContractQueryBuilder, self).__init__(context)
        self._fields = {
            'id': Contract.id,
            '_id': Contract.id,
            'num': Contract.num,
            'date': Contract.date,
        }
        self._simple_search_fields = [
            Contract.num
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = self.query.join(Contract, Resource.contract)
        super(ContractQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Contract.id.in_(id))
