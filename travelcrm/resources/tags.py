# -*-coding: utf-8 -*-
from zope.interface import implementer

from ..interfaces import (
    IResourceType,
)
from ..resources import (
    ResourceTypeBase,
)


@implementer(IResourceType)
class TagsResource(ResourceTypeBase):

    __name__ = 'tags'

    @property
    def allowed_scopes(self):
        return False
