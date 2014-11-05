# -*-coding: utf-8 -*-

import colander

from . import ResourceSchema

from ..models.account import Account
from ..lib.bl.subaccounts import get_subaccounts_types


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


def subaccount_type_validator(node, kw):
    return colander.OneOf(
        map(lambda x: x.name, get_subaccounts_types())
    )


class SubaccountSchema(ResourceSchema):
    account_id = colander.SchemaNode(
        colander.Integer(),
    )
    subaccount_type = colander.SchemaNode(
        colander.String(),
        validator=subaccount_type_validator
    )
    source_id = colander.SchemaNode(
        colander.Integer(),
    )
    name = colander.SchemaNode(
        colander.String(),
        validator=name_validator
    )
    descr = colander.SchemaNode(
        colander.String(),
        missing=None,
        validator=colander.Length(max=255)
    )
