# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.supplier_type import SupplierType


class SuppliersTypesQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(SuppliersTypesQueryBuilder, self).__init__(context)
        self._fields = {
            'id': SupplierType.id,
            '_id': SupplierType.id,
            'name': SupplierType.name
        }
        self._simple_search_fields = [
            SupplierType.name
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = self.query.join(SupplierType, Resource.supplier_type)
        super(SuppliersTypesQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(SupplierType.id.in_(id))
