# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.company import Company


class CompaniesQueryBuilder(ResourcesQueryBuilder):
    _fields = {
        'id': Company.id,
        '_id': Company.id,
        'name': Company.name
    }
    _simple_search_fields = [
        Company.name
    ]

    def __init__(self, context):
        super(CompaniesQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = self.query.join(Company, Resource.company)
        self.query = self.query.add_columns(*fields)

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Company.id.in_(id))
