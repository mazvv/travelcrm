# -*-coding: utf-8 -*-

from zope.interface import implementer

from finbroker.interfaces import (
    IResource,
    IResourcesContainer,
)
from finbroker.resources import (
    Admin,
)

from finbroker.admin.resources import (
    SecuredBase,
    ResourceBase
)


@implementer(IResource)
@implementer(IResourcesContainer)
class Regions(SecuredBase):

    __name__ = 'regions'

    def __init__(self, request):
        self.__parent__ = Admin(request)
        self.request = request


@implementer(IResource)
class Region(ResourceBase):

    __name__ = 'region'

    def __init__(self, request):
        self.__parent__ = Regions(request)
        self.request = request
