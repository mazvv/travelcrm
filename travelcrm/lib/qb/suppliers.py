# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder

from ...models.resource import Resource
from ...models.supplier import Supplier


class SuppliersQueryBuilder(ResourcesQueryBuilder):
    _fields = {
        'id': Supplier.id,
        '_id': Supplier.id,
        'name': Supplier.name
    }

    _simple_search_fields = [
        Supplier.name,
    ]

    def __init__(self, context):
        super(SuppliersQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = self.query.join(Supplier, Resource.supplier)
        self.query = self.query.add_columns(*fields)

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Supplier.id.in_(id))
