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
from ..models.group import Group as _Group


@implementer(IResource)
@implementer(IResourcesContainer)
class Groups(ResourcesContainerBase):

    __name__ = 'groups'

    _fields = {
        'group.name': _Group.name,
    }

    def __init__(self, request):
        self.__parent__ = Root(request)
        self.request = request

    def get_query_base(self):
        base_query = self._get_query_base()
        query = base_query.join(
            _Group,
            Resource.group
        )
        fields = [
            field.label(label_name)
            for label_name, field
            in self._fields.iteritems()
        ]
        query = query.add_columns(*fields)
        return query


@implementer(IResource)
class Group(ResourceBase):

    __name__ = 'group'

    def __init__(self, request):
        self.__parent__ = Groups(request)
        self.request = request
