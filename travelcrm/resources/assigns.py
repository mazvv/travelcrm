# -*-coding: utf-8 -*-

from zope.interface import implementer

from ..interfaces import (
    IResourceType,
)
from ..resources import (
    ResourceTypeBase,
)
from ..lib.utils.common_utils import translate as _


@implementer(IResourceType)
class AssignsResource(ResourceTypeBase):

    __name__ = 'assigns'

    @property
    def allowed_permisions(self):
        return [
            ('assign', _(u'assign')),
        ]

    @property
    def allowed_scopes(self):
        return False
