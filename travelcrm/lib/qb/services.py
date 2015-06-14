# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder
from ...models.resource_type import ResourceType
from ...models.resource import Resource
from ...models.service import Service


class ServicesQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(ServicesQueryBuilder, self).__init__(context)
        self._fields = {
            'id': Service.id,
            '_id': Service.id,
            'name': Service.name,
            'resource_type': ResourceType.humanize,
        }
        self._simple_search_fields = [
            Service.name,
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = (
            self.query
            .join(Service, Resource.service)
            .join(ResourceType, Service.resource_type)
        )
        super(ServicesQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Service.id.in_(id))
