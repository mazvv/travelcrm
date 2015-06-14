# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.company import Company


class CompaniesQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(CompaniesQueryBuilder, self).__init__(context)
        self._fields = {
            'id': Company.id,
            '_id': Company.id,
            'name': Company.name
        }
        self._simple_search_fields = [
            Company.name
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = self.query.join(Company, Resource.company)
        super(CompaniesQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Company.id.in_(id))
