# -*-coding: utf-8 -*-
from zope.interface import implementer

from ..interfaces import (
    IResourceType,
)
from ..resources import (
    ResourceTypeBase,
)


@implementer(IResourceType)
class SuppliersTypesResource(ResourceTypeBase):

    __name__ = 'suppliers_types'

    @property
    def allowed_assign(self):
        return True
