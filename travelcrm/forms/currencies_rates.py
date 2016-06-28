# -*-coding: utf-8 -*-

import colander

from . import (
    SelectInteger,
    ResourceSchema,
    ResourceSearchSchema,
    Date,
    BaseForm,
    BaseSearchForm,
    BaseAssignForm,
)
from ..models.currency import Currency
from ..models.supplier import Supplier
from ..models.currency_rate import CurrencyRate
from ..models.note import Note
from ..models.task import Task
from ..resources.currencies_rates import CurrenciesRatesResource
from ..lib.qb.currencies_rates import CurrenciesRatesQueryBuilder
from ..lib.utils.common_utils import translate as _
from ..lib.utils.common_utils import get_base_currency, cast_int
from ..lib.utils.security_utils import get_auth_employee


@colander.deferred
def date_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        currency = Currency.get(cast_int(request.params.get('currency_id')))
        supplier = Supplier.get(cast_int(request.params.get('supplier_id')))
        
        rate = CurrencyRate.get_by_currency(
            currency and currency.id, supplier and supplier.id, value
        )
        if (
            rate
            and (
                str(rate.id) != request.params.get('id')
                or (
                    str(rate.id) == request.params.get('id')
                    and request.view_name == 'copy'
                )
            )
        ):
            raise colander.Invalid(
                node,
                _(u'Currency rate for this date exists'),
            )
    return validator


@colander.deferred
def currency_validator(node, kw):

    def validator(node, value):
        currency = Currency.get(cast_int(value))
        if currency and currency.iso_code == get_base_currency():
            raise colander.Invalid(
                node,
                _(u'This is base currency'),
            )
    return validator


@colander.deferred
def rate_validator(node, kw):

    def validator(node, value):
        if value <= 0:
            raise colander.Invalid(
                node,
                _(u'Must be more then 0'),
            )
    return validator


class _CurrencyRateSchema(ResourceSchema):
    currency_id = colander.SchemaNode(
        SelectInteger(Currency),
        validator=currency_validator
    )
    supplier_id = colander.SchemaNode(
        SelectInteger(Supplier),
    )
    rate = colander.SchemaNode(
        colander.Money(),
        validator=rate_validator
    )
    date = colander.SchemaNode(
        Date(),
        validator=date_validator
    )


class _CurrencyRateSearchSchema(ResourceSearchSchema):
    supplier_id = colander.SchemaNode(
        colander.Integer(),
        missing=None
    )
    rate_from = colander.SchemaNode(
        Date(),
        missing=None
    )
    rate_to = colander.SchemaNode(
        Date(),
        missing=None
    )

class CurrencyRateForm(BaseForm):
    _schema = _CurrencyRateSchema

    def submit(self, currency_rate=None):
        if not currency_rate:
            currency_rate = CurrencyRate(
                resource=CurrenciesRatesResource.create_resource(
                    get_auth_employee(self.request)
                )
            )
        else:
            currency_rate.resource.notes = []
            currency_rate.resource.tasks = []
        currency_rate.date = self._controls.get('date')
        currency_rate.currency_id = self._controls.get('currency_id')
        currency_rate.supplier_id = self._controls.get('supplier_id')
        currency_rate.rate = self._controls.get('rate')
        for id in self._controls.get('note_id'):
            note = Note.get(id)
            currency_rate.resource.notes.append(note)
        for id in self._controls.get('task_id'):
            task = Task.get(id)
            currency_rate.resource.tasks.append(task)
        return currency_rate


class CurrencyRateSearchForm(BaseSearchForm):
    _schema = _CurrencyRateSearchSchema
    _qb = CurrenciesRatesQueryBuilder
    

class CurrencyRateAssignForm(BaseAssignForm):
    def submit(self, ids):
        for id in ids:
            currency_rate = CurrencyRate.get(id)
            currency_rate.resource.maintainer_id = self._controls.get(
                'maintainer_id'
            )
