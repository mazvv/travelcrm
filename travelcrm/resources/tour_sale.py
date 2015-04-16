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
from ..lib.factories.tours_sales import (
    TourSaleInvoiceFactory,
    TourSaleCalculationFactory,
)
from ..lib.utils.common_utils import translate as _


@implementer(IResourceType)
@implementer(IInvoiceFactory)
@implementer(ICalculationFactory)
class TourSaleResource(ResourceTypeBase):

    __name__ = 'tour_sale'

    @property
    def allowed_permisions(self):
        return super(TourSaleResource, self).allowed_permisions + [
            ('invoice', _(u'invoice')),
            ('calculation', _(u'calculation')),
            ('contract', _(u'contract')),
        ]

    @staticmethod
    def get_invoice_factory():
        return TourSaleInvoiceFactory

    @staticmethod
    def get_calculation_factory():
        return TourSaleCalculationFactory
