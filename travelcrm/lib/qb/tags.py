# -*coding: utf-8-*-
from collections import Iterable

from sqlalchemy import or_

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.tag import Tag


class TagsQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(TagsQueryBuilder, self).__init__(context)
        self._fields = {
            'id': Tag.id,
            '_id': Tag.id,
            'name': Tag.name
        }
        self._simple_search_fields = [
            Tag.name
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = self.query.join(Tag, Resource.tag)
        super(TagsQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Tag.id.in_(id))

    def search_simple(self, term):
        if term and term.strip():
            term = term.strip()
            terms = set(map(lambda x: x.strip(), term.split(',')))
            condition = []
            for term in terms:
                term = "%s%%" % term
                condition += map(
                    lambda item: item.ilike(term), self._simple_search_fields
                )
            self.query = self.query.filter(or_(*condition))
