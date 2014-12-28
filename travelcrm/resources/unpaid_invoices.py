# -*-coding: utf-8 -*-


from zope.interface import implementer

from ..interfaces import (
    IResourceType,
    IPortlet,
)
from ..resources import (
    Root,
)
from ..resources import (
    ResourceTypeBase,
)
from ..lib.utils.common_utils import translate as _


@implementer(IResourceType)
@implementer(IPortlet)
class UnpaidInvoices(ResourceTypeBase):

    __name__ = 'unpaid_invoices'

    def __init__(self, request):
        self.__parent__ = Root(request)
        self.request = request

    @property
    def allowed_permisions(self):
        return [
            ('view', _(u'view')),
        ]

    @property
    def allowed_scopes(self):
        return False
