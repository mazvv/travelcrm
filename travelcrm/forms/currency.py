# -*-coding: utf-8 -*-

import colander

from . import(
    ResourceSchema, 
    ResourceSearchSchema
)
from ..models.currency import Currency
from ..lib.utils.common_utils import translate as _


@colander.deferred
def iso_code_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        currency = Currency.by_iso_code(value)
        if (
            currency
            and str(currency.id) != request.params.get('id')
        ):
            raise colander.Invalid(
                node,
                _(u'Currency with the same iso code exists'),
            )
    return colander.All(colander.Length(min=3, max=3), validator,)


class CurrencySchema(ResourceSchema):
    iso_code = colander.SchemaNode(
        colander.String(),
        validator=iso_code_validator
    )


class CurrencySearchSchema(ResourceSearchSchema):
    pass
