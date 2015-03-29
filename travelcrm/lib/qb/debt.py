# -*coding: utf-8-*-

from sqlalchemy import func, and_, or_

from . import ResourcesQueryBuilder
from ...models import DBSession
from ...models.resource import Resource
from ...models.account import Account
from ...models.subaccount import Subaccount
from ...models.calculation import Calculation
from ...models.service_item import ServiceItem
from ...models.touroperator import Touroperator
from ...models.currency import Currency
from ...models.transfer import Transfer

from ...lib.bl.calculations import query_resource_data


class DebtQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(DebtQueryBuilder, self).__init__(context)
        self._subq_transfers = (
            DBSession.query(
                Transfer.sum,
                Transfer.date, 
                Touroperator.id,
                Account.currency_id.label('currency_id')
            )
            .join(Subaccount, Transfer.subaccount_from)
            .join(Touroperator, Subaccount.touroperator)
            .join(Account, Subaccount.account)
            .subquery()
        )
        subq_resource_data = query_resource_data().subquery()
        self._subq_calculations = (
            DBSession.query(
                subq_resource_data.c.date,
                Calculation.price.label('sum'),
                Calculation.currency_id,
                ServiceItem.touroperator_id,
            )
            .join(ServiceItem, Calculation.service_item)
            .join(
                subq_resource_data, 
                ServiceItem.id == subq_resource_data.c.service_item_id
            )
            .subquery()
        )
        self._field_sum_in = func.coalesce(
            func.sum(self._subq_transfers.c.sum), 0
        )
        self._field_sum_out = func.coalesce(
            func.sum(self._subq_calculations.c.sum), 0
        )
        self._fields = {
            'id': Touroperator.id,
            '_id': Touroperator.id,
            'name': Touroperator.name,
            'currency': Currency.iso_code,
            'sum_in': self._field_sum_in,
            'sum_out': self._field_sum_out,
            'balance': (self._field_sum_out - self._field_sum_in)
        }
        self._simple_search_fields = [
            Touroperator.name,
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = (
            self.query
            .join(Touroperator, Resource.touroperator)
            .outerjoin(
                self._subq_calculations, 
                self._subq_calculations.c.touroperator_id == Touroperator.id,
            )
            .join(
                Currency, self._subq_calculations.c.currency_id == Currency.id
            )
            .outerjoin(
                self._subq_transfers, 
                and_(
                    self._subq_transfers.c.id == Touroperator.id,
                    self._subq_transfers.c.currency_id == Currency.id
                )
            )
            .group_by(Touroperator.id, Touroperator.name, Currency.iso_code)
        )
        super(DebtQueryBuilder, self).build_query()
        self.query = self.query.with_entities(
            Touroperator.id, Touroperator.name, 
            Currency.iso_code.label('currency'),
            self._field_sum_in.label('sum_in'),
            self._field_sum_out.label('sum_out'),
            (self._field_sum_out - self._field_sum_in).label('balance')
        )

    def advanced_search(self, **kwargs):
        if 'date_from' in kwargs or 'date_to' in kwargs:
            self._filter_date(
                kwargs.get('date_from'), kwargs.get('date_to')
            )
        if 'currency_id' in kwargs:
            self._filter_currency(kwargs.get('currency_id'))

    def _filter_date(self, date_from, date_to):
        if date_from:
            self.query = self.query.filter(
                or_(
                    self._subq_calculations.c.date >= date_from,
                    self._subq_transfers.c.date >= date_from,
                )
            )
        if date_to:
            self.query = self.query.filter(
                or_(
                    self._subq_calculations.c.date <= date_to,
                    self._subq_transfers.c.date <= date_to,
                )
            )
    
    def _filter_currency(self, currency_id):
        if currency_id:
            self.query = self.query.filter(
                Currency.id == currency_id
            )
