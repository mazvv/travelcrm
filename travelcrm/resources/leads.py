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
class LeadsResource(ResourceTypeBase):

    __name__ = 'leads'

    @property
    def allowed_permisions(self):
        return super(LeadsResource, self).allowed_permisions + [
            ('order', _(u'order')),
        ]

    @property
    def allowed_assign(self):
        return True
