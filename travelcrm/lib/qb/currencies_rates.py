# -*coding: utf-8-*-
from collections import Iterable

from sqlalchemy import literal

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.currency_rate import CurrencyRate
from ...models.currency import Currency
from ...models.supplier import Supplier
from ...lib.utils.common_utils import get_base_currency


class CurrenciesRatesQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(CurrenciesRatesQueryBuilder, self).__init__(context)
        self._fields = {
            'id': CurrencyRate.id,
            '_id': CurrencyRate.id,
            'iso_code': Currency.iso_code,
            'supplier': Supplier.name,
            'rate': CurrencyRate.rate,
            'date': CurrencyRate.date,
            'base_currency': literal(get_base_currency())
        }
        self._simple_search_fields = [
            Currency.iso_code,
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = (
            self.query
            .join(CurrencyRate, Resource.currency_rate)
            .join(Currency, CurrencyRate.currency)
            .join(Supplier, CurrencyRate.supplier)
        )
        super(CurrenciesRatesQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(CurrencyRate.id.in_(id))

    def advanced_search(self, **kwargs):
        super(CurrenciesRatesQueryBuilder, self).advanced_search(**kwargs)
        if 'currency_id' in kwargs:
            self._filter_currency_id(
                kwargs.get('currency_id')
            )
        if 'supplier_id' in kwargs:
            self._filter_supplier_id(
                kwargs.get('supplier_id')
            )
        if 'rate_from' in kwargs or 'rate_to' in kwargs:
            self._filter_rate_date(
                kwargs.get('rate_from'), kwargs.get('rate_to')
            )

    def _filter_currency_id(self, currency_id):
        if currency_id:
            self.query = self.query.filter(
                CurrencyRate.currency_id == currency_id
            )

    def _filter_supplier_id(self, supplier_id):
        if supplier_id:
            self.query = self.query.filter(
                CurrencyRate.supplier_id == supplier_id
            )

    def _filter_rate_date(self, rate_from, rate_to):
        if rate_from:
            self.query = self.query.filter(
                CurrencyRate.date >= rate_from
            )
        if rate_to:
            self.query = self.query.filter(
                CurrencyRate.date <= rate_to
            )
