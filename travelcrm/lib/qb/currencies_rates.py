# -*coding: utf-8-*-
from collections import Iterable

from sqlalchemy import literal

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.currency_rate import CurrencyRate
from ...models.currency import Currency
from ...lib.utils.common_utils import get_base_currency


class CurrenciesRatesQueryBuilder(ResourcesQueryBuilder):
    _fields = {
        'id': CurrencyRate.id,
        '_id': CurrencyRate.id,
        'iso_code': Currency.iso_code,
        'rate': CurrencyRate.rate,
        'date': CurrencyRate.date,
    }
    _simple_search_fields = [
        Currency.iso_code,
    ]

    def __init__(self, context):
        super(CurrenciesRatesQueryBuilder, self).__init__(context)
        self._fields['base_currency'] = literal(get_base_currency())
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = self.query.join(CurrencyRate, Resource.currency_rate)
        self.query = self.query.join(Currency, CurrencyRate.currency)
        self.query = self.query.add_columns(*fields)

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(CurrencyRate.id.in_(id))

    def advanced_search(self, **kwargs):
        super(CurrenciesRatesQueryBuilder, self).advanced_search(**kwargs)
        if 'rate_from' in kwargs or 'rate_to' in kwargs:
            self._filter_rate_date(
                kwargs.get('rate_from'), kwargs.get('rate_to')
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
