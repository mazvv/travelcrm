# -*coding: utf-8-*-

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.resource_type import ResourceType


class ResourcesTypesQueryBuilder(ResourcesQueryBuilder):
    _fields = {
        'id': ResourceType.id,
        '_id': ResourceType.id,
        'name': ResourceType.name,
        'humanize': ResourceType.humanize,
        'module': ResourceType.module,
        'description': ResourceType.description,
    }
    _simple_search_fields = [
        ResourceType.name,
        ResourceType.humanize,
        ResourceType.module,
    ]

    def __init__(self, context):
        super(ResourcesTypesQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = self.query.join(ResourceType, Resource.resource_type_obj)
        self.query = self.query.add_columns(*fields)

    def filter_id(self, id):
        if id:
            self.query = self.query.filter(ResourceType.id == id)
