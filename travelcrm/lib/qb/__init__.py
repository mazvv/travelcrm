# -*-coding: utf-8-*-

from datetime import datetime

from sqlalchemy import desc, asc, or_, and_, text, cast, Boolean
from sqlalchemy.orm import aliased
from zope.interface.verify import verifyObject

from ...interfaces import IResourceType
from ...models import DBSession
from ...models.resource import Resource
from ...models.structure import Structure
from ...models.employee import Employee
from ...models.position import Position
from ...models.appointment import Appointment

from ..utils.common_utils import serialize
from ..utils.security_utils import get_auth_employee

from ..bl.employees import (
    query_employee_scope,
    query_employees_position
)
from sqlalchemy.orm.util import outerjoin


class NotValidContextError(Exception):
    pass


def query_row_serialize_format(row, serializers=None):
    res_row = dict(zip(row.keys(), row))
    for key, value in res_row.iteritems():
        if serializers and serializers.get(key):
            res_row[key] = serializers.get(key)(value, row)
        else:
            res_row[key] = serialize(value)
    return res_row


def query_serialize(query):
    return [query_row_serialize_format(row) for row in query]


class GeneralQueryBuilder(object):

    _fields = {}
    _simple_search_fields = []
    _advanced_search_fields = []
    _serializers = {}

    def build_base_query(self):
        raise NotImplementedError(
            "Not implemented build base query"
        )

    def build_query(self):
        fields = self.get_fields_with_labels()
        self.query = self.query.with_entities(*fields)

    def get_query(self):
        return self.query

    def get_fields_with_labels(self):
        fields = self.get_fields()
        return [
            field.label(label_name)
            for label_name, field
            in fields.iteritems()
        ]

    def get_sort_order(self, sort, order):
        fields = self.get_fields()
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
        self.query = self.query.order_by(
            self.get_sort_order(sort, order)
        )

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
            result.append(query_row_serialize_format(row, self._serializers))
        return result


class ResourcesQueryBuilder(GeneralQueryBuilder):

    _aEmployee = aliased(Employee)
    _aSubscriber = aliased(Employee)
    _aStructure = aliased(Structure)
    _base_fields = {
        'rid': Resource.id.label('rid'),
        'modifydt': Resource.modifydt.label('modifydt'),
        'maintainer': _aEmployee.name,
    }

    def __init__(self, context=None):
        if context and not verifyObject(IResourceType, context):
            raise NotValidContextError()
        self.context = context

    def build_base_query(self):
        structure_subq = (
            query_employees_position()
            .with_entities(
                Appointment.employee_id.label('employee_id'),
                Position.structure_id.label('structure_id'),
            )
            .subquery()
        )
        self.query = (
            DBSession.query(*self.get_base_fields().values())
            .join(self._aEmployee, Resource.maintainer)
            .join(
                structure_subq,
                self._aEmployee.id == structure_subq.c.employee_id
            )
            .join(
                self._aStructure,
                structure_subq.c.structure_id == self._aStructure.id
            )
        )
        if self.context:
            employee = get_auth_employee(self.context.request)
            query = query_employee_scope(employee, self.context)
            if query:
                subq = query.subquery()
                self.query = self.query.join(
                    subq, subq.c.id == self._aStructure.id
                )
            self._subscriptions(employee)

    def _subscriptions(self, employee):
        subscription_subq = (
            DBSession.query(Resource.id)
            .join(self._aSubscriber, Resource.subscribers)
            .filter(self._aSubscriber.id == employee.id)
            .subquery()
        )
        self.query = self.query.outerjoin(
            subscription_subq, subscription_subq.c.id == Resource.id
        )
        self.update_fields({
            'subscriber': subscription_subq.c.id
        })

    def update_fields(self, fields):
        self._fields.update(fields)

    def get_base_fields(self):
        return self._base_fields

    def get_fields(self):
        fields = super(ResourcesQueryBuilder, self).get_fields()
        fields.update(self.get_base_fields())
        return fields

    def advanced_search(self, **kwargs):
        self._filter_updated_date(
            kwargs.get('updated_from'), kwargs.get('updated_to')
        )
        self._filter_maintainer(kwargs.get('maintainer_id'))

    def _filter_updated_date(self, updated_from, updated_to):
        if updated_from:
            updated_from = datetime.combine(updated_from, datetime.min.time())
            self.query = self.query.filter(Resource.modifydt >= updated_from)
        if updated_to:
            updated_to = datetime.combine(updated_to, datetime.max.time())
            self.query = self.query.filter(Resource.modifydt <= updated_to)

    def _filter_maintainer(self, maintainer_id):
        if maintainer_id:
            self.query = self.query.filter(
                Resource.maintainer_id == maintainer_id
            )
