from zope.interface import implementer

from ..interfaces import (
    IResourceType,
)
from ..resources import (
    ResourceTypeBase,
)


@implementer(IResourceType)
class MailsResource(ResourceTypeBase):

    __name__ = 'mails'

    @property
    def allowed_assign(self):
        return True
