# -*-coding: utf-8 -*-

from zope.interface import implementer

from ..interfaces import (
    IResourceType,
    ISubaccountFactory,
)
from ..resources import (
    ResourceTypeBase
)
from ..lib.factories.suppliers import SupplierSubaccountFactory


@implementer(IResourceType)
@implementer(ISubaccountFactory)
class SupplierResource(ResourceTypeBase):

    __name__ = 'supplier'

    @staticmethod
    def get_subaccount_factory():
        return SupplierSubaccountFactory
