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
class TurnoversResource(ResourceTypeBase):

    __name__ = 'turnovers'

    @property
    def allowed_permisions(self):
        return [
            ('view', _(u'view')),
        ]

    @property
    def allowed_scopes(self):
        return False
