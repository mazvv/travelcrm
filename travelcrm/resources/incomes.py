# -*-coding: utf-8 -*-

from zope.interface import implementer

from ..interfaces import (
    IResourceType,
    IIncomePaymentFactory,
)
from ..resources import (
    Root,
)
from ..resources import (
    ResourceTypeBase
)
from ..lib.bl.incomes import IncomePaymentsFactory
from ..lib.utils.common_utils import translate as _


@implementer(IResourceType)
@implementer(IIncomePaymentFactory)
class Incomes(ResourceTypeBase):

    __name__ = 'incomes'

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
        ]

    @staticmethod
    def get_income_payment_factory():
        return IncomePaymentsFactory
