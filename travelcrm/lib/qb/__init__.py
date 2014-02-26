# -*-coding: utf-8-*-

from abc import ABCMeta

from datetime import datetime, date
from sqlalchemy import desc, asc, or_
from sqlalchemy.orm import aliased
from babel.dates import format_datetime, format_date
from zope.interface.verify import verifyObject

from ...interfaces import IResourceType
from ...models import DBSession
from ...models.resource import Resource
from ...models.user import User
from ...models.structure import Structure
from ...models.resource_log import ResourceLog

from ..utils.common_utils import get_locale_name
from ..utils.security_utils import get_auth_employee

from ..bl.employees import query_employee_scope


class NotValidContextError(Exception):
    pass


def query_row_serialize_format(row):
    locale_name = get_locale_name()
    res_row = dict(zip(row.keys(), row))
    for key, value in res_row.iteritems():
        if isinstance(value, date):
            res_row[key] = format_date(
                value, format="short", locale=locale_name
            )
        if isinstance(value, datetime):
            res_row[key] = format_datetime(
                value, format="short", locale=locale_name
            )
    return res_row


class GeneralQueryBuilder(object):
    __metaclass__ = ABCMeta

    _fields = {}
    _searcher = None
    _simple_search_fields = []
    _advanced_search_fields = []
    
    """ Need to implement self.query
    """

    def get_query(self):
        return self.query

    @staticmethod
    def get_fields_with_labels(fields):
        assert isinstance(fields, dict), u"fields must be dict"
        return [
            field.label(label_name)
            for label_name, field
            in fields.iteritems()
        ]

    @staticmethod
    def get_sort_order(fields, sort, order):
        sort = fields.get(sort)
        assert sort is not None, u"Sort can't be None"
        order = asc if order == 'asc' else desc
        return order(sort)

    def get_fields(self):
        return self._fields

    def search_simple(self, term):
        term = term.strip()
        if term:
            term = "%s%%" % term
            condition = or_(
                *map(lambda item: item.ilike(term), self._simple_search_fields)
            )
            self.query = self.query.filter(condition)

    def sort_query(self, sort, order):
        all_fields = {}
        all_fields.update(self.get_fields())
        sort_order = GeneralQueryBuilder.get_sort_order(
            all_fields, sort, order
        )
        self.query = self.query.order_by(sort_order)

    def page_query(self, limit, page=1):
        assert isinstance(limit, int), type(limit)
        assert isinstance(page, int), type(page)

        offset = limit * (page - 1)
        if limit:
            self.query = self.query.limit(limit).offset(offset)
        else:
            self.query = self.query.offset(offset)

    def get_count(self):
        query = self.get_query()
        return query.limit(None).offset(0).count()

    def get_serialized(self):
        query = self.get_query()
        result = []
        for row in query:
            result.append(query_row_serialize_format(row))
        return result


class ResourcesQueryBuilder(GeneralQueryBuilder):

    __log_subquery = ResourceLog.query_last_max_entries().subquery()
    __base_fields = {
        'rid': Resource.id.label('rid'),
        'status': Resource.status.label('status'),
        'modifydt': __log_subquery.c.modifydt.label('modifydt'),
        'modifier': __log_subquery.c.modifier.label('modifier'),
    }

    def __init__(self, context=None):

        if context and not verifyObject(IResourceType, context):
            raise NotValidContextError()

        aStructure = aliased(Structure)
        self.query = (
            DBSession.query(*self.get_base_fields().values())
            .join(aStructure, Resource.owner_structure)
            .outerjoin(
                self.__log_subquery,
                Resource.id == self.__log_subquery.c.id
            )
        )
        if context:
            employee = get_auth_employee(context.request)
            query = query_employee_scope(employee, context)
            if query:
                subq = query_employee_scope(employee, context).subquery()
                self.query = self.query.join(subq, subq.c.id == aStructure.id)

    def get_base_fields(self):
        return self.__base_fields

    def sort_query(self, sort, order):
        all_fields = {}
        all_fields.update(self.get_base_fields())
        all_fields.update(self.get_fields())
        sort_order = ResourcesQueryBuilder.get_sort_order(
            all_fields, sort, order
        )
        self.query = self.query.order_by(sort_order)
