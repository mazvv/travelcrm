# -*-coding: utf-8 -*-
from zope.interface import implementer

from ..interfaces import (
    IResourceType,
    ISubaccountFactory,
)
from ..resources import (
    ResourceTypeBase,
)
from ..lib.factories.companies import CompanySubaccountFactory
from ..lib.utils.common_utils import translate as _


@implementer(IResourceType)
@implementer(ISubaccountFactory)
class CompaniesResource(ResourceTypeBase):

    __name__ = 'companies'

    @property
    def allowed_permisions(self):
        return [
            ('view', _(u'view')),
            ('edit', _(u'edit')),
        ]

    @staticmethod
    def get_subaccount_factory():
        return CompanySubaccountFactory
