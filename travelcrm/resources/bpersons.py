# -*-coding: utf-8 -*-
from zope.interface import implementer

from ..interfaces import (
    IResourceType,
)
from ..resources import (
    ResourceTypeBase,
)


@implementer(IResourceType)
class BPersonsResource(ResourceTypeBase):

    __name__ = 'bpersons'

    @property
    def allowed_assign(self):
        return True
