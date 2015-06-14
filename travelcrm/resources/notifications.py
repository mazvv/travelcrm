# -*-coding: utf-8 -*-
from zope.interface import implementer

from ..interfaces import (
    IResourceType,
)
from ..resources import (
    ResourceTypeBase,
)
from ..lib.utils.common_utils import translate as _


@implementer(IResourceType)
class NotificationsResource(ResourceTypeBase):

    __name__ = 'notifications'

    @property
    def allowed_permisions(self):
        return [
            ('view', _(u'view')),
            ('close', _(u'close')),
        ]

    @property
    def allowed_scopes(self):
        return False
