# -*-coding: utf-8 -*-
from zope.interface import implementer

from ..interfaces import (
    IResourceType,
)
from ..resources import (
    ResourceTypeBase,
)


@implementer(IResourceType)
class CurrenciesRatesResource(ResourceTypeBase):

    __name__ = 'currencies_rates'

    @property
    def allowed_assign(self):
        return True
