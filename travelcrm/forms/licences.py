# -*-coding: utf-8 -*-

import colander
from babel.dates import parse_date

from . import Date, ResourceSchema


@colander.deferred
def date_validator(node, kw):
    request = kw.get('request')
    _ = request.translate

    def validator(node, value):
        if value >= parse_date(request.params.get('date_to')):
            raise colander.Invalid(node, _(u"Invalid dates, please check"))
    return colander.All(validator)


class LicenceSchema(ResourceSchema):
    licence_num = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(min=2, max=32)
    )
    date_from = colander.SchemaNode(
        Date(),
        validator=date_validator
    )
    date_to = colander.SchemaNode(
        Date(),
    )
