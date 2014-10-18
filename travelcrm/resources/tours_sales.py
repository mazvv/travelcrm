# -*-coding: utf-8 -*-
from zope.interface import implementer

from ..interfaces import (
    IResourceType,
    IInvoiceFactory,
)
from ..resources import (
    Root,
)
from ..resources import (
    ResourceTypeBase,
)
from travelcrm.lib.bl.tours_sales import TourSaleInvoiceFactory
from ..lib.utils.common_utils import translate as _


@implementer(IResourceType)
@implementer(IInvoiceFactory)
class ToursSales(ResourceTypeBase):

    __name__ = 'tours_sales'

    def __init__(self, request):
        self.__parent__ = Root(request)
        self.request = request

    @property
    def allowed_permisions(self):
        return [
            ('view', _(u'view')),
            ('add', _(u'add')),
            ('edit', _(u'edit')),
            ('delete', _(u'delete')),
            ('settings', _(u'settings')),
            ('invoice', _(u'invoice')),
            ('calculation', _(u'calculation')),
            ('contract', _(u'contract')),
        ]

    @staticmethod
    def get_invoice_factory():
        return TourSaleInvoiceFactory
