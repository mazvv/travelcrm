# -*-coding: utf-8 -*-
from zope.interface import implementer

from ..interfaces import (
    IResourceType,
)
from ..resources import (
    ResourceTypeBase,
)


@implementer(IResourceType)
class Notifications(ResourceTypeBase):

    __name__ = 'notifications'

    @property
    def allowed_permisions(self):
        return [
            ('view', _(u'view')),
            ('delete', _(u'delete')),
        ]

    @property
    def allowed_scopes(self):
        return False
