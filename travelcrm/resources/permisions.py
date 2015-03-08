# -*-coding: utf-8 -*-
from zope.interface import implementer

from ..interfaces import (
    IResourceType,
)
from ..resources import (
    ResourceTypeBase,
)


@implementer(IResourceType)
class Permisions(ResourceTypeBase):

    __name__ = 'permisions'
