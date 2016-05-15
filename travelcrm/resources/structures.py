# -*-coding: utf-8 -*-
from zope.interface import implementer

from ..interfaces import (
    IResourceType,
)
from ..resources import (
    ResourceTypeBase,
)


@implementer(IResourceType)
class StructuresResource(ResourceTypeBase):

    __name__ = 'structures'

    @classmethod
    def get_subaccount_factory(cls):
        return None

    @property
    def allowed_assign(self):
        return True
