# -*-coding: utf-8 -*-
from zope.interface import implementer

from ..interfaces import (
    IResourceType,
)
from ..resources import (
    ResourceTypeBase,
)


@implementer(IResourceType)
class PersonsCategoriesResource(ResourceTypeBase):

    __name__ = 'persons_categories'

    @property
    def allowed_assign(self):
        return True
