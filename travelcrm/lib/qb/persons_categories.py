# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.person_category import PersonCategory


class PersonsCategoriesQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(PersonsCategoriesQueryBuilder, self).__init__(context)
        self._fields = {
            'id': PersonCategory.id,
            '_id': PersonCategory.id,
            'name': PersonCategory.name
        }
        self._simple_search_fields = [
            PersonCategory.name
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = self.query.join(PersonCategory, Resource.person_category)
        super(PersonsCategoriesQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(PersonCategory.id.in_(id))
