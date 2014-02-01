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


@implementer(IResource)
@implementer(IResourcesContainer)
class Users(ResourcesContainerBase):

    __name__ = 'users'

    def __init__(self, request):
        self.__parent__ = Root(request)
        self.request = request

    @property
    def allowed_permisions(self):
        _ = self.request.translate
        return [
            ('view', _(u'view')),
            ('delete', _(u'delete')),
        ]


@implementer(IResource)
class User(ResourceBase):

    __name__ = 'user'

    def __init__(self, request):
        self.__parent__ = Users(request)
        self.request = request

    @property
    def allowed_permisions(self):
        _ = self.request.translate
        return [
            ('add', _(u'add')),
            ('edit', _(u'edit')),
        ]
