# -*-coding: utf-8 -*-
from zope.interface import implementer

from ..interfaces import (
    IResourceType,
    IInvoiceFactory,
    ICalculationFactory,
)
from ..resources import (
    Root,
)
from ..resources import (
    ResourceTypeBase,
)
from ..lib.bl.services_sales import ServiceSaleInvoiceFactory
from ..lib.bl.services_sales import ServiceSaleCalculationFactory
from ..lib.utils.common_utils import translate as _


@implementer(IResourceType)
@implementer(IInvoiceFactory)
@implementer(ICalculationFactory)
class ServicesSales(ResourceTypeBase):

    __name__ = 'services_sales'

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
            ('calculation', _(u'calculation')),
            ('invoice', _(u'invoice')),
            ('contract', _(u'contract')),
        ]

    @staticmethod
    def get_invoice_factory():
        return ServiceSaleInvoiceFactory

    @staticmethod
    def get_calculation_factory():
        return ServiceSaleCalculationFactory
