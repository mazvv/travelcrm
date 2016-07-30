# -*-coding:utf-8-*-

import logging

from pyramid.security import (
    Allow,
    Authenticated,
    Deny,
    ALL_PERMISSIONS,
    has_permission,
)

from ..lib.utils.resources_utils import (
    get_resource_class,
    get_resource_settings,
    ResourceClassNotFound,
)
from ..lib.utils.security_utils import get_auth_employee
from ..lib.utils.common_utils import translate as _
from ..lib.bl.employees import get_employee_permisions

from ..models.resource import Resource

log = logging.getLogger(__name__)


class SecuredBase(object):

    @property
    def __acl__(self):
        permisions = SecuredBase.get_permisions(self, self.request)
        acls = [
            (Allow, Authenticated, permisions),
            (Deny, Authenticated, ALL_PERMISSIONS)
        ]
        return acls

    def __getitem__(self, key):
        try:
            resource_type = get_resource_class(key)
            return resource_type(self.request)
        except ResourceClassNotFound:
            raise KeyError

    def has_permision(self, permision):
        return has_permission(permision, self, self.request)

    def has_all_permisions(self, permissions):
        for permision in permissions:
            if not has_permission(permision, self, self.request):
                return False
        return True

    def has_any_permision(self, permissions):
        for permision in permissions:
            if has_permission(permision, self, self.request):
                return True
        return False

    @staticmethod
    def get_permisions(obj, request):
        employee = get_auth_employee(request)
        if employee:
            employee_permisions = get_employee_permisions(employee, obj)
            if employee_permisions:
                return employee_permisions.permisions

    def is_logged(self):
        return self.request.authenticated_userid


class Root(SecuredBase):

    __name__ = None
    __parent__ = None

    def __init__(self, request):
        self.request = request

    @property
    def allowed_permisions(self):
        return [
            ('view', _(u'view')),
        ]

    @property
    def allowed_scopes(self):
        return False

    @property
    def allowed_settings(self):
        return False


class ResourceTypeBase(SecuredBase):

    def __init__(self, request):
        self.__parent__ = Root(request)
        self.request = request

    @property
    def allowed_scopes(self):
        return True

    @property
    def allowed_settings(self):
        return False

    @property
    def allowed_assign(self):
        return False

    @property
    def allowed_permisions(self):
        permisions = [
            ('view', _(u'view')),
            ('add', _(u'add')),
            ('edit', _(u'edit')),
            ('delete', _(u'delete')),
        ]
        if self.allowed_settings:
            permisions.append(('settings', _(u'settings')))
        if self.allowed_assign:
            permisions.append(('assign', _(u'assign')))
        return permisions

    @classmethod
    def create_resource(cls, employee):
        resource = Resource(cls, employee)
        return resource

    def get_settings(self):
        return get_resource_settings(self)
