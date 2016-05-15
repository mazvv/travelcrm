# -*-coding: utf-8 -*-
from zope.interface import implementer

from ..interfaces import (
    IResourceType,
)
from ..resources import (
    ResourceTypeBase,
)


@implementer(IResourceType)
class AccomodationsResource(ResourceTypeBase):

    __name__ = 'accomodations'

    @property
    def allowed_assign(self):
        return True
