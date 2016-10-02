#-*-coding:utf-8-*-

from .resources import ResourceCreated
from ..utils.security_utils import get_auth_employee
from ..utils.common_utils import translate as _


class TaskCreated(ResourceCreated):

    @property
    def descr(self):
        return (
            _(u'New task "%s" was created by %s')
            % (
               self.obj.title,
               get_auth_employee(self.request).name
            )
        )
