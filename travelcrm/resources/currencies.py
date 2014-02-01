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
class Currencies(SecuredBase):

    __name__ = 'currencies'

    def __init__(self, request):
        self.__parent__ = Admin(request)
        self.request = request

    @property
    def allowed_permisions(self):
        _ = self.request.translate
        return [
            ('view', _(u'view')),
            ('delete', _(u'delete')),
        ]


@implementer(IResource)
class Currency(ResourceBase):

    __name__ = 'currency'

    def __init__(self, request):
        self.__parent__ = Currencies(request)
        self.request = request

    @property
    def allowed_permisions(self):
        _ = self.request.translate
        return [
            ('add', _(u'add')),
            ('edit', _(u'edit')),
        ]
