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


@implementer(IResourceType)
class Advsources(ResourceTypeBase):

    __name__ = 'advsources'
