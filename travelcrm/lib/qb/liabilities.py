# -*coding: utf-8-*-
from collections import Iterable

from sqlalchemy import func, literal

from . import ResourcesQueryBuilder
from ...models import DBSession
from ...models.resource import Resource
from ...models.liability import Liability
from ...models.invoice import Invoice
from ...models.service import Service
from ...models.touroperator import Touroperator
from ...models.currency import Currency
from ...models.resource_type import ResourceType

from ...lib.bl.liabilities import query_resource_data
from ...lib.utils.common_utils import (
    get_base_currency,
    parse_date,
)


class LiabilitiesQueryBuilder(ResourcesQueryBuilder):
    _subq_resource_type = (
        DBSession.query(ResourceType.humanize, Resource.id)
        .join(Resource, ResourceType.resources)
        .subquery()
    )

    _subq_resource_data = query_resource_data().subquery()

    _fields = {
        'id': Liability.id,
        '_id': Liability.id,
        'date': Liability.date,
        'resource_sum': _subq_resource_data.c.resource_sum,
        'base_price': _subq_resource_data.c.base_price,
        'profit': _subq_resource_data.c.profit,
        'resource_type': _subq_resource_type.c.humanize,
    }
    _simple_search_fields = [
        Service.name,
        Touroperator.name,
        _subq_resource_type.c.humanize,
    ]

    def __init__(self, context):
        super(LiabilitiesQueryBuilder, self).__init__(context)
        self._fields['base_currency'] = literal(get_base_currency())
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = (
            self.query
            .join(Liability, Resource.liability)
            .join(
                self._subq_resource_data,
                self._subq_resource_data.c.liability_id
                == Liability.id
            )
            .join(
                self._subq_resource_type,
                self._subq_resource_type.c.id
                == self._subq_resource_data.c.resource_id
            )
        )

        self.query = self.query.add_columns(*fields)

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Invoice.id.in_(id))

    def advanced_search(self, **kwargs):
        super(LiabilitiesQueryBuilder, self).advanced_search(**kwargs)
        if 'currency_id' in kwargs:
            self._filter_currency(kwargs.get('currency_id'))
        if 'sum_from' in kwargs or 'sum_to' in kwargs:
            self._filter_sum(
                kwargs.get('sum_from'), kwargs.get('sum_to')
            )
        if 'payment_from' in kwargs or 'payment_to' in kwargs:
            self._filter_payment(
                kwargs.get('payment_from'), kwargs.get('payment_to')
            )
        if 'date_from' in kwargs or 'date_to' in kwargs:
            self._filter_invoice_date(
                kwargs.get('date_from'), kwargs.get('date_to')
            )

    def _filter_currency(self, currency_id):
        if currency_id:
            self.query = self.query.filter(Currency.id == currency_id)

    def _filter_sum(self, sum_from, sum_to):
        if sum_from:
            self.query = self.query.filter(
                self._subq_invoice_sum >= sum_from
            )
        if sum_to:
            self.query = self.query.filter(
                self._subq_invoice_sum <= sum_to
            )

    def _filter_payment(self, payment_from, payment_to):
        if payment_from:
            self.query = self.query.filter(
                func.coalesce(self._sum_payments.c.sum, 0) >= payment_from
            )
        if payment_to:
            self.query = self.query.filter(
                func.coalesce(self._sum_payments.c.sum, 0) <= payment_to
            )

    def _filter_invoice_date(self, date_from, date_to):
        if date_from:
            self.query = self.query.filter(
                Invoice.date >= parse_date(date_from)
            )
        if date_to:
            self.query = self.query.filter(
                Invoice.date <= parse_date(date_to)
            )
