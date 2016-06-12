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
class OrdersResource(ResourceTypeBase):

    __name__ = 'orders'

    @property
    def allowed_permisions(self):
        return super(OrdersResource, self).allowed_permisions + [
            ('calculation', _(u'calculation')),
            ('invoice', _(u'invoice')),
            ('contract', _(u'contract')),
        ]

    @property
    def allowed_settings(self):
        return True

    @property
    def allowed_assign(self):
        return True
