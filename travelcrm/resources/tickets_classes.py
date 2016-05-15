# -*-coding: utf-8 -*-
from zope.interface import implementer

from ..interfaces import (
    IResourceType,
)
from ..resources import (
    ResourceTypeBase,
)


@implementer(IResourceType)
class TicketsClassesResource(ResourceTypeBase):

    __name__ = 'tickets_classes'

    @property
    def allowed_assign(self):
        return True
