# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.accomodation_type import AccomodationType


class AccomodationTypeQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(AccomodationTypeQueryBuilder, self).__init__(context)
        self._fields = {
            'id': AccomodationType.id,
            '_id': AccomodationType.id,
            'name': AccomodationType.name
        }
        self._simple_search_fields = [
            AccomodationType.name
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = self.query.join(
            AccomodationType, Resource.accomodation_type
        )
        super(AccomodationTypeQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(AccomodationType.id.in_(id))
