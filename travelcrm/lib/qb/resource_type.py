# -*coding: utf-8-*-

from collections import Iterable

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.resource_type import ResourceType


class ResourceTypeQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(ResourceTypeQueryBuilder, self).__init__(context)
        self._fields = {
            'id': ResourceType.id,
            '_id': ResourceType.id,
            'name': ResourceType.name,
            'humanize': ResourceType.humanize,
            'module': ResourceType.module,
            'customizable': ResourceType.customizable,
            'description': ResourceType.description,
            'status': ResourceType.status,
        }
        self._simple_search_fields = [
            ResourceType.name,
            ResourceType.humanize,
            ResourceType.module,
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = self.query.join(ResourceType, Resource.resource_type_obj)
        super(ResourceTypeQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(ResourceType.id.in_(id))
