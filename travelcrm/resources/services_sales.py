# -*-coding: utf-8 -*-
from zope.interface import implementer

from ..interfaces import (
    IResourceType,
    IInvoiceFactory,
    ICalculationFactory,
)
from ..resources import (
    ResourceTypeBase,
)
from ..lib.factories.services_sales import (
    ServiceSaleInvoiceFactory,
    ServiceSaleCalculationFactory
)
from ..lib.utils.common_utils import translate as _


@implementer(IResourceType)
@implementer(IInvoiceFactory)
@implementer(ICalculationFactory)
class ServicesSales(ResourceTypeBase):

    __name__ = 'services_sales'

    @property
    def allowed_permisions(self):
        return super(ServicesSales, self).allowed_permisions + [
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
