# -*-coding:utf-8-*-

import logging
import importlib
from datetime import datetime
from zope.interface import implementer

from sqlalchemy import asc, desc
from babel.dates import format_datetime
from pyramid.security import (
    Allow,
    Authenticated,
    Deny,
    ALL_PERMISSIONS,
    authenticated_userid
)
from webhelpers.paginate import Page

from ..lib.resources_utils import (
    get_resource_class,
    get_resource_permissions,
    ResourceClassNotFound,
)

from ..models import DBSession
from ..models.resource import Resource
from ..models.resource_log import ResourceLog
from ..models.resource_type import ResourceType
from ..models.user import User

log = logging.getLogger(__name__)


class SecuredBase(object):

    @property
    def __acl__(self):
        permissions = get_resource_permissions(self)
        acls = [
            (Allow, Authenticated, permissions),
            (Deny, Authenticated, ALL_PERMISSIONS)
        ]
        return acls

    def is_logged(self):
        return authenticated_userid(self.request)


class ResourcesContainerBase(SecuredBase):

    def __getitem__(self, key):
        try:
            resource_type = get_resource_class(key)
            return resource_type(self.request)
        except ResourceClassNotFound:
            raise KeyError


class ResourceBase(SecuredBase):

    def create_resource(self, status):
        resource = Resource(self.__class__, status)
        resource.owner_id = authenticated_userid(self.request)
        return resource

    def __getitem__(self, key):
        raise KeyError

    @property
    def allowed_scopes(self):
        return True


class Root(ResourcesContainerBase):

    __name__ = None
    __parent__ = None

    def __init__(self, request):
        self.request = request

    @property
    def allowed_permisions(self):
        _ = self.request.translate
        return [
            ('view', _(u'view')),
        ]
