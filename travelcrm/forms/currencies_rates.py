# -*-coding: utf-8 -*-

import colander

from . import ResourceSchema, Date
from ..models.currency import Currency
from ..models.currency_rate import CurrencyRate

from ..lib.utils.common_utils import translate as _
from ..lib.utils.common_utils import get_base_currency


@colander.deferred
def date_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        currency = Currency.get(request.params.get('currency_id'))
        rate = CurrencyRate.get_by_currency(currency.id, value)
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


class CurrencyRateSchema(ResourceSchema):
    currency_id = colander.SchemaNode(
        colander.Integer(),
        validator=currency_validator
    )
    rate = colander.SchemaNode(
        colander.Money(),
        validator=rate_validator
    )
    date = colander.SchemaNode(
        Date(),
        validator=date_validator
    )
