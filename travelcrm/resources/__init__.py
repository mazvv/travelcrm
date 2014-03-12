# -*-coding:utf-8-*-

import logging
from zope.interface import implementer

from pyramid.security import (
    Allow,
    Authenticated,
    Deny,
    ALL_PERMISSIONS,
    authenticated_userid,
    has_permission,
)

from ..lib.utils.resources_utils import (
    get_resource_class,
    ResourceClassNotFound,
)
from ..lib.utils.security_utils import get_auth_employee
from ..lib.bl.employees import (
    get_employee_permisions,
    get_employee_structure
)

from ..models.resource import Resource
from ..models.user import User

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

    @staticmethod
    def get_permisions(obj, request):
        employee = get_auth_employee(request)
        if employee:
            employee_permisions = get_employee_permisions(employee, obj)
            if employee_permisions:
                return employee_permisions.permisions

    def is_logged(self):
        return authenticated_userid(self.request)


class ResourceTypeBase(SecuredBase):

    def create_resource(self, status):
        auth_employee = get_auth_employee(self.request)
        assert auth_employee, "Not auth user can't create resource"
        owner_structure = get_employee_structure(auth_employee)
        resource = Resource(self.__class__, owner_structure, status)
        return resource

    @property
    def allowed_scopes(self):
        return True


class Root(SecuredBase):

    __name__ = None
    __parent__ = None

    def __init__(self, request):
        self.request = request
