# -*-coding: utf-8 -*-

import colander

from . import ResourceSchema
from ..models.account import Account


@colander.deferred
def name_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        account = Account.by_name(value)
        if (
            account
            and str(account.id) != request.params.get('id')
        ):
            raise colander.Invalid(
                node,
                _(u'Account with the same name exists'),
            )
    return colander.All(colander.Length(max=255), validator,)


class AccountSchema(ResourceSchema):
    currency_id = colander.SchemaNode(
        colander.Integer(),
    )
    name = colander.SchemaNode(
        colander.String(),
        validator=name_validator
    )
    account_type = colander.SchemaNode(
        colander.String(),
        validator=colander.OneOf(map(lambda x: x[0], Account.ACCOUNTS_TYPES))
    )
    display_text = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=255)
    )
    descr = colander.SchemaNode(
        colander.String(),
        missing=None,
        validator=colander.Length(max=255)
    )
