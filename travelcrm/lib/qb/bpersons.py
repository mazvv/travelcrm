# -*coding: utf-8-*-

from collections import Iterable

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.bperson import BPerson


class BPersonsQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(BPersonsQueryBuilder, self).__init__(context)
        self._fields = {
            'id': BPerson.id,
            '_id': BPerson.id,
            'name': BPerson.name,
            'position_name': BPerson.position_name,
            'status': BPerson.status,
        }
        self._simple_search_fields = [
            BPerson.first_name,
            BPerson.last_name,
            BPerson.position_name,
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = self.query.join(BPerson, Resource.bperson)
        super(BPersonsQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(BPerson.id.in_(id))
