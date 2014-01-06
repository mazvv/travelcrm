# -*-coding: utf-8 -*-

from zope.interface import implementer

from finbroker.interfaces import (
    IResource,
    IResourcesContainer,
)
from finbroker.resources import (
    Admin,
    ResourceClassNotFound,
    get_resource_class,
)

from finbroker.admin.resources import (
    SecuredBase,
    ResourceBase
)


@implementer(IResource)
@implementer(IResourcesContainer)
class GroupsNavigations(SecuredBase):

    __name__ = 'groups_navigations'

    def __init__(self, request):
        self.__parent__ = Admin(request)
        self.request = request

    def __getitem__(self, key):
        try:
            resource_type = get_resource_class(key)
            return resource_type(self.request)
        except ResourceClassNotFound:
            raise KeyError


@implementer(IResource)
class GroupNavigation(ResourceBase):

    __name__ = 'group_navigation'

    def __init__(self, request):
        self.__parent__ = GroupsNavigations(request)
        self.request = request

    def __getitem__(self, key):
        raise KeyError
