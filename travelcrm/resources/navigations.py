# -*-coding: utf-8 -*-
from zope.interface import implementer

from ..interfaces import (
    IResourceType,
)
from ..resources import (
    ResourceTypeBase,
)


@implementer(IResourceType)
class NavigationsResource(ResourceTypeBase):

    __name__ = 'navigations'

    @property
    def allowed_assign(self):
        return True
