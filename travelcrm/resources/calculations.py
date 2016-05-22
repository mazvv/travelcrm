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
class CalculationsResource(ResourceTypeBase):

    __name__ = 'calculations'

    @property
    def allowed_permisions(self):
        permisions = (
            super(CalculationsResource, self).allowed_permisions
        )
        permisions.append(
            ('autoload', _(u'autoload'))
        )
        return permisions
