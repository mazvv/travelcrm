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
class PositionsNavigations(ResourcesContainerBase):

    __name__ = 'positions_navigations'

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
class PositionNavigation(ResourceBase):

    __name__ = 'position_navigation'

    def __init__(self, request):
        self.__parent__ = PositionsNavigations(request)
        self.request = request

    @property
    def allowed_permisions(self):
        _ = self.request.translate
        return [
            ('add', _(u'add')),
            ('edit', _(u'edit')),
        ]
