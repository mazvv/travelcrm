# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.ticket_class import TicketClass


class TicketsClassesQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(TicketsClassesQueryBuilder, self).__init__(context)
        self._fields = {
            'id': TicketClass.id,
            '_id': TicketClass.id,
            'name': TicketClass.name
        }
        self._simple_search_fields = [
            TicketClass.name
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = self.query.join(TicketClass, Resource.ticket_class)
        super(TicketsClassesQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(TicketClass.id.in_(id))
