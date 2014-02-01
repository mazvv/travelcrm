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
class Companies(ResourcesContainerBase):

    __name__ = 'companies'

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
class Company(ResourceBase):

    __name__ = 'company'

    def __init__(self, request):
        self.__parent__ = Companies(request)
        self.request = request

    @property
    def allowed_permisions(self):
        _ = self.request.translate
        return [
            ('add', _(u'add')),
            ('edit', _(u'edit')),
        ]
