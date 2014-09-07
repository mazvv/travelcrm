# -*-coding: utf-8 -*-

from zope.interface import implementer

from ..interfaces import (
    IResourceType,
    IOutgoingPaymentFactory,
)
from ..resources import (
    Root,
)
from ..resources import (
    ResourceTypeBase
)
from ..lib.bl.refunds import RefundPaymentsFactory
from ..lib.utils.common_utils import translate as _


@implementer(IResourceType)
@implementer(IOutgoingPaymentFactory)
class Refunds(ResourceTypeBase):

    __name__ = 'refunds'

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
        ]

    @staticmethod
    def get_outgoing_payment_factory():
        return RefundPaymentsFactory
