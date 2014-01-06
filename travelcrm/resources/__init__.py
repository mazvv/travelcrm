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

    __log_subquery = ResourceLog.query_last_max_entries().subquery()

    __fields_base = {
        'rid': Resource.rid,
        '_rid': Resource.rid.label('_rid'),
        'status': Resource.status.label('status'),
        'owner': User.username.label('owner'),
        'modifydt': __log_subquery.c.modifydt.label('modifydt'),
        'modifier': __log_subquery.c.modifier.label('modifier'),
    }

    def __getitem__(self, key):
        try:
            resource_type = get_resource_class(key)
            return resource_type(self.request)
        except ResourceClassNotFound:
            raise KeyError

    def _get_query_base(self):
        return (
            DBSession.query(*self.__fields_base.values())
            .join(
                User,
                Resource.owner
            )
            .outerjoin(
                self.__log_subquery,
                Resource.rid == self.__log_subquery.c.rid
            )
        )

    def get_query_base(self):
        raise NotImplementedError()

    def get_fields(self):
        if not hasattr(self, '_fields'):
            raise NotImplementedError(u"Need to define _fields attribute")
        fields = self._fields.copy()
        fields.update(self.__fields_base)
        return fields

    def get_query(self, sort, order):
        fields = self.get_fields()
        sort = fields.get(sort)
        assert sort is not None, u"Sort can't be None"
        order = asc if order == 'asc' else desc
        return self.get_query_base().order_by(order(sort))

    def get_page(self, sort, order, page, rows):
        query = self.get_query(sort, order)
        items_count = query.count()
        page = Page(
            collection=query,
            page=int(page),
            items_per_page=int(rows),
            item_count=items_count
        )
        return items_count, page

    def get_json_page(self, sort, order, page, rows):
        items_count, page = self.get_page(
            sort, order, page, rows
        )

        def _to_dict(row, settings):
            row = dict(zip(row.keys(), row))
            for key, value in row.iteritems():
                if isinstance(value, datetime):
                    row[key] = format_datetime(
                        value,
                        locale=settings.get('pyramid.default_locale_name'),
                        format='short'
                    )
            return row

        settings = self.request.registry.settings
        return {
            'total': items_count,
            'rows': [_to_dict(row, settings) for row in page.items]
        }


class ResourceBase(SecuredBase):

    def create_resource(self, status):
        resource = Resource(self.__class__, status)
        resource._owner_users_rid = authenticated_userid(self.request)
        return resource

    def __getitem__(self, key):
        raise KeyError


class Root(ResourcesContainerBase):

    __name__ = None
    __parent__ = None

    def __init__(self, request):
        self.request = request
