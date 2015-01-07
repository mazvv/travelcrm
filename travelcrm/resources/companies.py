# -*-coding: utf-8 -*-


from zope.interface import implementer

from ..interfaces import (
    IResourceType,
)
from ..resources import (
    Root,
)
from ..resources import (
    ResourceTypeBase,
)
from ..lib.utils.common_utils import translate as _


@implementer(IResourceType)
class Companies(ResourceTypeBase):

    __name__ = 'companies'

    def __init__(self, request):
        self.__parent__ = Root(request)
        self.request = request

    @property
    def allowed_permisions(self):
        return [
            ('add', _(u'add')),
            ('edit', _(u'edit')),
            ('view', _(u'view')),
            ('delete', _(u'delete')),
        ]
