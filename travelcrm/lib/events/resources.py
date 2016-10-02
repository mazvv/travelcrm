#-*-coding:utf-8-*-

from . import BaseMixinEvent

from ..utils.security_utils import get_auth_employee
from ..utils.common_utils import translate as _


class ResourceCreated(BaseMixinEvent):

    @property
    def descr(self):
        return (
            _(u'New resource "%s" was created by %s')
            % (
               self.obj.resource.resource_type.humanize,
               get_auth_employee(self.request).name
            )
        )


class ResourceChanged(BaseMixinEvent):

    @property
    def descr(self):
        return (
            _(u'Resource "%s" was changed by %s')
            % (
                self.obj.resource.resource_type.humanize,
                get_auth_employee(self.request).name
            )
        )


class ResourceDeleted(BaseMixinEvent):

    @property
    def descr(self):
        return (
            _(u'%s deleted by %s')
            % (
               self.obj.resource.resource_type.humanize,
               get_auth_employee(self.request).name
            )
        )


class ResourceAssigned(BaseMixinEvent):

    @property
    def descr(self):
        return (
            _(u'%s assigned to %s by %s')
            % (
                self.obj.resource.resource_type.humanize,
                self.obj.maintainer.name,
                get_auth_employee(self.request).name
            )
        )
