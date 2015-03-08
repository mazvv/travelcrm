# -*-coding: utf-8 -*-

from zope.interface import implementer

from ..interfaces import (
    IResourceType,
    IPortlet,
)
from ..resources import (
    ResourceTypeBase,
)
from ..lib.utils.common_utils import translate as _


@implementer(IResourceType)
@implementer(IPortlet)
class UnpaidInvoices(ResourceTypeBase):

    __name__ = 'unpaid_invoices'

    @property
    def allowed_permisions(self):
        return [
            ('view', _(u'view')),
            ('settings', _(u'settings')),
        ]

    @property
    def allowed_scopes(self):
        return False
