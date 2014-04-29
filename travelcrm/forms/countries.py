# -*-coding: utf-8 -*-

import colander

from . import ResourceSchema
from ..models.country import Country
from ..lib.utils.common_utils import translate as _


@colander.deferred
def iso_code_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        country = Country.by_iso_code(value)
        if (
            country
            and str(country.id) != request.params.get('id')
        ):
            raise colander.Invalid(
                node,
                _(u'Country with the same iso code exists'),
            )
    return colander.All(colander.Length(min=2, max=2), validator,)


class CountrySchema(ResourceSchema):
    iso_code = colander.SchemaNode(
        colander.String(),
        validator=iso_code_validator
    )
    name = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(min=2, max=32),
    )
