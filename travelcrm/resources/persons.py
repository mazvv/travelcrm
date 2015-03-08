# -*-coding: utf-8 -*-
from zope.interface import implementer

from ..interfaces import (
    IResourceType,
    ISubaccountFactory,
)
from ..resources import (
    ResourceTypeBase,
)
from ..lib.factories.persons import PersonSubaccountFactory


@implementer(IResourceType)
@implementer(ISubaccountFactory)
class Persons(ResourceTypeBase):

    __name__ = 'persons'

    @staticmethod
    def get_subaccount_factory():
        return PersonSubaccountFactory
