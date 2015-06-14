# -*-coding: utf-8 -*-
from zope.interface import implementer

from ..interfaces import (
    IResourceType,
)
from ..resources import (
    ResourceTypeBase
)


@implementer(IResourceType)
class CommissionsResource(ResourceTypeBase):

    __name__ = 'commissions'
