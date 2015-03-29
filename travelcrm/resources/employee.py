# -*-coding: utf-8 -*-
from zope.interface import implementer

from ..interfaces import (
    IResourceType,
    ISubaccountFactory,
)
from ..resources import (
    ResourceTypeBase,
)
from ..lib.factories.employees import EmployeeSubaccountFactory


@implementer(IResourceType)
@implementer(ISubaccountFactory)
class EmployeeResource(ResourceTypeBase):

    __name__ = 'employee'

    @staticmethod
    def get_subaccount_factory():
        return EmployeeSubaccountFactory
