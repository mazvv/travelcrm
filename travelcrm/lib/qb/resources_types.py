# -*coding: utf-8-*-

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.resource_type import ResourceType


class ResourcesTypesQueryBuilder(ResourcesQueryBuilder):
    _fields = {
        'id': ResourceType.id,
        '_id': ResourceType.id,
        'rt_name': ResourceType.name,
        'rt_humanize': ResourceType.humanize,
        'rt_module': ResourceType.module,
        'rt_description': ResourceType.description,
    }

    def __init__(self, context):
        super(ResourcesTypesQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = self.query.join(ResourceType, Resource.resource_type_obj)
        self.query = self.query.add_columns(*fields)
