# -*-coding: utf-8 -*-
from zope.interface import implementer

from ..interfaces import (
    IResourceType,
    IInvoiceFactory,
    ILiabilityFactory,
)
from ..resources import (
    Root,
)
from ..resources import (
    ResourceTypeBase,
)
from ..lib.bl.tours import (
    TourInvoiceFactory,
    TourLiabilityFactory
)
from ..lib.utils.common_utils import translate as _


@implementer(IResourceType)
@implementer(IInvoiceFactory)
@implementer(ILiabilityFactory)
class Tours(ResourceTypeBase):

    __name__ = 'tours'

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
            ('liability', _(u'liability')),
            ('contract', _(u'contract')),
        ]

    @staticmethod
    def get_invoice_factory():
        return TourInvoiceFactory

    @staticmethod
    def get_liability_factory():
        return TourLiabilityFactory
