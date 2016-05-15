# -*-coding: utf-8 -*-
from zope.interface import implementer

from ..interfaces import (
    IResourceType,
)
from ..resources import (
    ResourceTypeBase,
)


@implementer(IResourceType)
class CampaignsResource(ResourceTypeBase):

    __name__ = 'campaigns'

    @property
    def allowed_settings(self):
        return True

    @property
    def allowed_assign(self):
        return True
