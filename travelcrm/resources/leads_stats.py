from zope.interface import implementer

from ..interfaces import (
    IResourceType,
    IPortlet,
)
from ..resources import (
    Root,
)
from ..resources import (
    ResourceTypeBase,
)
from ..lib.utils.common_utils import translate as _


@implementer(IResourceType)
@implementer(IPortlet)
class LeadsStatsResource(ResourceTypeBase):

    __name__ = 'leads_stats'

    def __init__(self, request):
        self.__parent__ = Root(request)
        self.request = request

    @property
    def allowed_permisions(self):
        return [
            ('view', _(u'view')),
            ('settings', _(u'settings')),
        ]

    @property
    def allowed_scopes(self):
        return False

    @property
    def allowed_settings(self):
        return True
