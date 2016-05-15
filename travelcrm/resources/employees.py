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
class EmployeesResource(ResourceTypeBase):

    __name__ = 'employees'

    @staticmethod
    def get_subaccount_factory():
        return EmployeeSubaccountFactory

    @property
    def allowed_assign(self):
        return True
