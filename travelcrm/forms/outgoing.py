# -*-coding: utf-8 -*-

from decimal import Decimal

import colander

from . import ResourceSchema, Date, ResourceSearchSchema
from ..models.subaccount import Subaccount
from ..lib.bl.cashflows import get_account_balance
from ..lib.utils.common_utils import parse_datetime, translate as _


@colander.deferred
def sum_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        if value <= 0:
            raise colander.Invalid(
                node,
                _(u'Sum must be more then zero'),
            )
        subaccount_id = int(request.params.get('subaccount_id'))
        date = parse_datetime(request.params.get('date'))
        sum = Decimal(request.params.get('sum'))
        subaccount = Subaccount.get(subaccount_id)
        balance = get_account_balance(subaccount.account_id, None, date)
        if balance < sum:
            raise colander.Invalid(
                node,
                _(u'Max amount for payment %s' % balance),
            )
    return colander.All(validator,)


class OutgoingSchema(ResourceSchema):
    date = colander.SchemaNode(
        Date(),
    )
    sum = colander.SchemaNode(
        colander.Money(),
        validator=sum_validator,
    )
    account_item_id = colander.SchemaNode(
        colander.Integer(),
    )
    subaccount_id = colander.SchemaNode(
        colander.Integer(),
    )


class OutgoingSearchSchema(ResourceSearchSchema):
    account_id = colander.SchemaNode(
        colander.Integer(),
        missing=None
    )
    account_item_id = colander.SchemaNode(
        colander.Integer(),
        missing=None
    )
    currency_id = colander.SchemaNode(
        colander.Integer(),
        missing=None
    )
    payment_from = colander.SchemaNode(
        Date(),
        missing=None
    )
    payment_to = colander.SchemaNode(
        Date(),
        missing=None
    )
    sum_from = colander.SchemaNode(
        colander.Decimal(),
        missing=None
    )
    sum_to = colander.SchemaNode(
        colander.Decimal(),
        missing=None
    )
