# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.accomodation import Accomodation


class AccomodationQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(AccomodationQueryBuilder, self).__init__(context)
        self._fields = {
            'id': Accomodation.id,
            '_id': Accomodation.id,
            'name': Accomodation.name
        }
        self._simple_search_fields = [
            Accomodation.name
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = self.query.join(
            Accomodation, Resource.accomodation
        )
        super(AccomodationQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Accomodation.id.in_(id))
