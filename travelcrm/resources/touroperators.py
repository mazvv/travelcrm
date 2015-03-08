# -*-coding: utf-8 -*-

from zope.interface import implementer

from ..interfaces import (
    IResourceType,
    ISubaccountFactory,
)
from ..resources import (
    ResourceTypeBase,
)
from ..lib.factories.touroperators import TouroperatorSubaccountFactory


@implementer(IResourceType)
@implementer(ISubaccountFactory)
class Touroperators(ResourceTypeBase):

    __name__ = 'touroperators'

    @staticmethod
    def get_subaccount_factory():
        return TouroperatorSubaccountFactory
