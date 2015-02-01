# -*coding: utf-8-*-

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.resource_type import ResourceType


class ResourcesTypesQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(ResourcesTypesQueryBuilder, self).__init__(context)
        self._fields = {
            'id': ResourceType.id,
            '_id': ResourceType.id,
            'name': ResourceType.name,
            'humanize': ResourceType.humanize,
            'module': ResourceType.module,
            'customizable': ResourceType.customizable,
            'description': ResourceType.description,
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
        super(ResourcesTypesQueryBuilder, self).build_query()

    def filter_id(self, id):
        if id:
            self.query = self.query.filter(ResourceType.id == id)
