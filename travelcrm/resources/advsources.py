# -*-coding: utf-8 -*-

from zope.interface import implementer

from ..interfaces import (
    IResourceType,
)
from ..resources import (
    ResourceTypeBase,
)


@implementer(IResourceType)
class AdvsourcesResource(ResourceTypeBase):

    __name__ = 'advsources'

    @property
    def allowed_assign(self):
        return True
