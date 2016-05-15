# -*-coding: utf-8 -*-
from zope.interface import implementer

from ..interfaces import (
    IResourceType,
)
from ..resources import (
    ResourceTypeBase,
)


@implementer(IResourceType)
class AccountsItemsResource(ResourceTypeBase):

    __name__ = 'accounts_items'

    @property
    def allowed_assign(self):
        return True
