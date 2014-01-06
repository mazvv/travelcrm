# -*-coding: utf-8 -*-

from zope.interface import implementer

from ..interfaces import (
    IResource,
    IResourcesContainer,
)
from ..resources import (
    Root,
)

from ..resources import (
    ResourcesContainerBase,
    ResourceBase,
)

from ..models.resource import Resource
from ..models.resource_type import ResourceType as _ResourceType


@implementer(IResource)
@implementer(IResourcesContainer)
class ResourcesTypes(ResourcesContainerBase):

    __name__ = 'resources_types'

    _fields = {
        'resourcetype.name': _ResourceType.name,
        'resourcetype.humanize': _ResourceType.humanize,
        'resourcetype.module': _ResourceType.module,
        'resourcetype.description': _ResourceType.description,
    }

    def __init__(self, request):
        self.__parent__ = Root(request)
        self.request = request

    def get_query_base(self):
        base_query = self._get_query_base()
        query = base_query.join(
            _ResourceType,
            Resource.resource_type_obj
        )
        fields = [
            field.label(label_name)
            for label_name, field
            in self._fields.iteritems()
        ]
        query = query.add_columns(*fields)
        return query


@implementer(IResource)
class ResourceType(ResourceBase):

    __name__ = 'resource_type'

    def __init__(self, request):
        self.__parent__ = ResourcesTypes(request)
        self.request = request
