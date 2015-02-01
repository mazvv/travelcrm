# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder

from ...models.resource import Resource
from ...models.supplier import Supplier


class SuppliersQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(SuppliersQueryBuilder, self).__init__(context)
        self._fields = {
            'id': Supplier.id,
            '_id': Supplier.id,
            'name': Supplier.name
        }
        self._simple_search_fields = [
            Supplier.name,
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = self.query.join(Supplier, Resource.supplier)
        super(SuppliersQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Supplier.id.in_(id))
