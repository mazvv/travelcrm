# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.lead import Lead
from ...models.person import Person
from ...models.advsource import Advsource


class LeadsQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(LeadsQueryBuilder, self).__init__(context)
        self._fields = {
            'id': Lead.id,
            '_id': Lead.id,
            'lead_date': Lead.lead_date,
            'customer': Person.name,
            'advsource': Advsource.name,
            'status': Lead.status,
        }
        self._simple_search_fields = [
            Person.first_name,
            Person.last_name,
            Person.name
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = (
            self.query
            .join(Lead, Resource.lead)
            .join(Person, Lead.customer)
            .join(Advsource, Lead.advsource)
        )
        super(LeadsQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Lead.id.in_(id))
