# -*-coding: utf-8 -*-

import colander

from . import ResourceSchema, Date
from ..lib.utils.common_utils import parse_date
from ..lib.utils.common_utils import translate as _


@colander.deferred
def valid_until_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        date = parse_date(request.params.get('date'))
        if date > value:
            raise colander.Invalid(
                node,
                _(u'Active until date must be more than invoice date'),
            )
    return colander.All(validator,)


class InvoiceAddSchema(ResourceSchema):
    resource_id = colander.SchemaNode(
        colander.Integer(),
    )
    date = colander.SchemaNode(
        Date(),
    )
    active_until = colander.SchemaNode(
        Date(),
        validator=valid_until_validator
    )
    account_id = colander.SchemaNode(
        colander.Integer()
    )


class InvoiceEditSchema(ResourceSchema):
    date = colander.SchemaNode(
        Date(),
    )
    active_until = colander.SchemaNode(
        Date(),
        validator=valid_until_validator
    )
    account_id = colander.SchemaNode(
        colander.Integer()
    )


class InvoiceSumSchema(ResourceSchema):
    resource_id = colander.SchemaNode(
        colander.Integer(),
    )
    date = colander.SchemaNode(
        Date(),
    )
    account_id = colander.SchemaNode(
        colander.Integer()
    )


class InvoiceActiveUntilSchema(ResourceSchema):
    date = colander.SchemaNode(
        Date(),
    )


class SettingsSchema(colander.Schema):
    active_days = colander.SchemaNode(
        colander.Integer(),
    )
