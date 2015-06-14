# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder

from ...models.resource import Resource
from ...models.supplier import Supplier
from ...models.supplier_type import SupplierType


class SuppliersQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(SuppliersQueryBuilder, self).__init__(context)
        self._fields = {
            'id': Supplier.id,
            '_id': Supplier.id,
            'name': Supplier.name,
            'supplier_type': SupplierType.name,
            'status': Supplier.status,
        }
        self._simple_search_fields = [
            Supplier.name,
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = (
            self.query.join(Supplier, Resource.supplier)
            .join(SupplierType, Supplier.supplier_type)
        )
        super(SuppliersQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Supplier.id.in_(id))

    def advanced_search(self, **kwargs):
        super(SuppliersQueryBuilder, self).advanced_search(**kwargs)
        if 'supplier_type_id' in kwargs:
            self._filter_supplier_type_id(
                kwargs.get('supplier_type_id')
            )

    def _filter_supplier_type_id(self, supplier_type_id):
        if supplier_type_id:
            self.query = self.query.filter(
                SupplierType.id == supplier_type_id
            )
