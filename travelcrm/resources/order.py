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
class OrderResource(ResourceTypeBase):

    __name__ = 'order'

    @property
    def allowed_permisions(self):
        return super(OrderResource, self).allowed_permisions + [
            ('calculation', _(u'calculation')),
            ('invoice', _(u'invoice')),
            ('contract', _(u'contract')),
        ]
