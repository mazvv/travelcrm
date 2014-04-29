# -*-coding: utf-8 -*-

import colander

from . import ResourceSchema
from ..lib.utils.common_utils import translate as _


@colander.deferred
def date_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        if not value and request.params.get('passport_type') == 'foreign':
            raise colander.Invalid(
                node,
                _(u"You must set end date for foreign passport")
            )
    return colander.All(validator)


class PassportSchema(ResourceSchema):
    country_id = colander.SchemaNode(
        colander.Integer()
    )
    passport_type = colander.SchemaNode(
        colander.String(),
        validator=colander.OneOf(('citizen', 'foreign'))
    )
    num = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(min=2, max=24)
    )
    end_date = colander.SchemaNode(
        colander.String(),
        missing=None,
        validator=date_validator
    )
    descr = colander.SchemaNode(
        colander.String(),
        missing=None,
        validator=colander.Length(min=2, max=255)
    )
