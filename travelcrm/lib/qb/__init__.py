# -*-coding: utf-8-*-

from collections import OrderedDict
from abc import ABCMeta
from decimal import Decimal

from datetime import datetime, date
from sqlalchemy import desc, asc, or_
from sqlalchemy.orm import aliased
from babel.dates import parse_date
from zope.interface.verify import verifyObject

from ...interfaces import IResourceType
from ...models import DBSession
from ...models.resource import Resource
from ...models.user import User
from ...models.structure import Structure
from ...models.resource_log import ResourceLog

from ..utils.common_utils import (
    get_locale_name, cast_int, format_date, format_datetime, format_decimal
)
from ..utils.security_utils import get_auth_employee

from ..bl.employees import query_employee_scope


class NotValidContextError(Exception):
    pass


def query_row_serialize_format(row):
    res_row = dict(zip(row.keys(), row))
    for key, value in res_row.iteritems():
        if isinstance(value, date):
            res_row[key] = format_date(value)
        if isinstance(value, datetime):
            res_row[key] = format_datetime(value)
        if isinstance(value, Decimal):
            res_row[key] = format_decimal(value)
    return res_row


def query_serialize(query):
    return [query_row_serialize_format(row) for row in query]


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
        if term and term.strip():
            term = term.strip()
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

        page = page or 1
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
    __base_fields = OrderedDict({
        'rid': Resource.id.label('rid'),
        'modifydt': __log_subquery.c.modifydt.label('modifydt'),
        'modifier': __log_subquery.c.modifier.label('modifier'),
    })

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

    def advanced_search(self, **kwargs):
        self._filter_updated_date(
            kwargs.get('updated_from'), kwargs.get('updated_to')
        )
        self._filter_modifier(kwargs.get('modifier_id'))

    def _filter_updated_date(self, updated_from, updated_to):
        if updated_from:
            self.query = self.query.filter(
                self.__log_subquery.c.modifydt >= parse_date(
                    updated_from, locale=get_locale_name()
                )
            )
        if updated_to:
            self.query = self.query.filter(
                self.__log_subquery.c.modifydt <= parse_date(
                    updated_to, locale=get_locale_name()
                )
            )

    def _filter_modifier(self, modifier_id):
        if modifier_id:
            self.query = self.query.filter(
                self.__log_subquery.c.modifier_id == cast_int(modifier_id)
            )
