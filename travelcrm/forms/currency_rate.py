# -*-coding: utf-8 -*-

import colander

from . import (
    ResourceSchema,
    ResourceSearchSchema, 
    Date,
    BaseForm,
    BaseSearchForm,
)
from ..models.currency import Currency
from ..models.supplier import Supplier
from ..models.currency_rate import CurrencyRate
from ..models.note import Note
from ..models.task import Task
from ..resources.currency_rate import CurrencyRateResource
from ..lib.qb.currency_rate import CurrencyRateQueryBuilder
from ..lib.utils.common_utils import translate as _
from ..lib.utils.common_utils import get_base_currency


@colander.deferred
def date_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        currency = Currency.get(request.params.get('currency_id'))
        supplier = Supplier.get(request.params.get('supplier_id'))
        rate = CurrencyRate.get_by_currency(
            currency.id, supplier.id, value
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
    return colander.All(validator,)


@colander.deferred
def currency_validator(node, kw):

    def validator(node, value):
        currency = Currency.get(value)
        if currency.iso_code == get_base_currency():
            raise colander.Invalid(
                node,
                _(u'This is base currency'),
            )
    return colander.All(validator,)


@colander.deferred
def rate_validator(node, kw):

    def validator(node, value):
        if value <= 0:
            raise colander.Invalid(
                node,
                _(u'Must be more then 0'),
            )
    return colander.All(validator,)


class _CurrencyRateSchema(ResourceSchema):
    currency_id = colander.SchemaNode(
        colander.Integer(),
        validator=currency_validator
    )
    supplier_id = colander.SchemaNode(
        colander.Integer(),
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
        context = CurrencyRateResource(self.request)
        if not currency_rate:
            currency_rate = CurrencyRate(
                resource=context.create_resource()
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
    _qb = CurrencyRateQueryBuilder
