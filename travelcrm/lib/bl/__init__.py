# -*-coding: utf-8-*-
'''
Business Logic
'''
from abc import ABCMeta

from datetime import datetime, date
from sqlalchemy import desc, asc
from babel.dates import format_datetime, format_date

from ...models import DBSession
from ...models.resource import Resource
from ...models.user import User
from ...models.resource_log import ResourceLog
from ..common_utils import get_locale_name


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
        'owner': User.username.label('owner'),
        'modifydt': __log_subquery.c.modifydt.label('modifydt'),
        'modifier': __log_subquery.c.modifier.label('modifier'),
    }
    _fields = {}

    def __init__(self):
        self.query = (
            DBSession.query(*self.get_base_fields().values())
            .join(User, Resource.owner)
            .outerjoin(
                self.__log_subquery,
                Resource.id == self.__log_subquery.c.id
            )
        )

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
