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
class Suppliers(ResourceTypeBase):

    __name__ = 'suppliers'

    @staticmethod
    def get_subaccount_factory():
        return SupplierSubaccountFactory
