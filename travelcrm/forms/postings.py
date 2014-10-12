# -*-coding: utf-8 -*-

import colander

from . import (
    ResourceSchema,
    Date,
)

from ..models.account import Account

from ..lib.utils.common_utils import translate as _
from ..lib.utils.common_utils import cast_int


@colander.deferred
def account_from_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        account_to_id = cast_int(request.params.get('account_to_id'))
        if not value and not account_to_id:
            raise colander.Invalid(
                node,
                _(u'Set at least one account'),
            )
    return colander.All(validator,)


@colander.deferred
def account_to_validator(node, kw):
    request = kw.get('request')
    def validator(node, value):
        account_from_id = cast_int(request.params.get('account_from_id'))
        if value and account_from_id:
            account_from = Account.get(account_from_id)
            account_to = Account.get(value)
            if account_from.currency_id != account_to.currency_id:
                raise colander.Invalid(
                    node,
                    _(u'Accounts with same currency allowed only'),
                )
    return colander.All(validator,)


class PostingSchema(ResourceSchema):
    date = colander.SchemaNode(
        Date(),
    )
    account_from_id = colander.SchemaNode(
        colander.Integer(),
        missing=None,
        validator=account_from_validator
    )
    account_to_id = colander.SchemaNode(
        colander.Integer(),
        missing=None,
        validator=account_to_validator
    )
    account_item_id = colander.SchemaNode(
        colander.Integer(),
    )
    sum = colander.SchemaNode(
        colander.Money(),
    )
