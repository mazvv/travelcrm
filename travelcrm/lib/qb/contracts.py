# -*coding: utf-8-*-

from collections import Iterable

from . import ResourcesQueryBuilder

from ...models.resource import Resource
from ...models.contract import Contract
from ...models.supplier import Supplier


class ContractsQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(ContractsQueryBuilder, self).__init__(context)
        self._fields = {
            'id': Contract.id,
            '_id': Contract.id,
            'num': Contract.num,
            'date': Contract.date,
            'supplier': Supplier.name,
            'status': Contract.status,
        }
        self._simple_search_fields = [
            Contract.num
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = (
            self.query.join(Contract, Resource.contract)
            .join(Supplier, Contract.supplier)
        )
        super(ContractsQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Contract.id.in_(id))

    def advanced_search(self, **kwargs):
        super(ContractsQueryBuilder, self).advanced_search(**kwargs)
        if 'supplier_id' in kwargs:
            self._filter_supplier_id(
                kwargs.get('supplier_id')
            )

    def _filter_supplier_id(self, supplier_id):
        if supplier_id:
            self.query = self.query.filter(
                Supplier.id == supplier_id
            )
