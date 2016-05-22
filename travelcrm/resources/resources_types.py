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
class ResourcesTypesResource(ResourceTypeBase):

    __name__ = 'resources_types'

    @property
    def allowed_assign(self):
        return True

    @property
    def allowed_permisions(self):
        permisions = (
            super(ResourcesTypesResource, self).allowed_permisions
        )
        permisions.append(
            ('settings', _(u'settings'))
        )
        return permisions
