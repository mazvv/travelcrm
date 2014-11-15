# -*-coding: utf-8 -*-

import colander

from . import (
    ResourceSchema,
    Date,
)

from ..models.account import Account
from ..models.subaccount import Subaccount

from ..lib.utils.common_utils import translate as _
from ..lib.utils.common_utils import cast_int


class AccountFromValidator(object):
    def __init__(self, request):
        self.request = request

    def __call__(self, node, value):
        request = self.request
        subaccount_from_id = cast_int(request.params.get('subaccount_from_id'))
        account_to_id = cast_int(request.params.get('account_to_id'))
        subaccount_to_id = cast_int(request.params.get('subaccount_to_id'))
        if not any(
            [value, account_to_id, subaccount_from_id, subaccount_to_id]
        ):
            raise colander.Invalid(
                node,
                _(u'Set at least one account or subaccount from any section'),
            )
        if value and subaccount_from_id:
            raise colander.Invalid(
                node,
                _(u'Set only account or subaccount or clear both')
            )
        

class AccountToValidator(object):
    def __init__(self, request):
        self.request = request

    def __call__(self, node, value):
        request = self.request
        account_from_id = cast_int(request.params.get('account_from_id'))
        subaccount_from_id = cast_int(request.params.get('subaccount_from_id'))
        subaccount_to_id = cast_int(request.params.get('subaccount_to_id'))
        
        currency_from_id = None
        currency_to_id = None

        if value and subaccount_to_id:
            raise colander.Invalid(
                node,
                _(u'Set only account or subaccount or clear both')
            )

        if value:
            account = Account.get(value)
            currency_to_id = account.currency_id
        elif subaccount_to_id:
            subaccount = Subaccount.get(subaccount_to_id)
            currency_to_id = subaccount.account.currency_id
            
        if account_from_id:
            account = Account.get(account_from_id)
            currency_from_id = account.currency_id
        elif subaccount_from_id:
            subaccount = Subaccount.get(subaccount_from_id)
            currency_from_id = subaccount.account.currency_id
            
        if (
            currency_from_id and currency_to_id 
            and currency_from_id == currency_to_id
        ):
            raise colander.Invalid(
                node,
                _(u'Transfer with same currency allowed only'),
            )


@colander.deferred
def account_from_validator(node, kw):
    request = kw.get('request')
    return colander.All(AccountFromValidator(request))


@colander.deferred
def account_to_validator(node, kw):
    request = kw.get('request')
    return colander.All(AccountToValidator(request))


class CrosspaymentSchema(ResourceSchema):

    date = colander.SchemaNode(
        Date(),
    )
    account_from_id = colander.SchemaNode(
        colander.Integer(),
        missing=None,
        validator=account_from_validator
    )
    subaccount_from_id = colander.SchemaNode(
        colander.Integer(),
        missing=None,
    )
    account_to_id = colander.SchemaNode(
        colander.Integer(),
        missing=None,
        validator=account_to_validator
    )
    subaccount_from_id = colander.SchemaNode(
        colander.Integer(),
        missing=None,
    )
    account_item_id = colander.SchemaNode(
        colander.Integer(),
    )
    sum = colander.SchemaNode(
        colander.Money(),
    )
    descr = colander.SchemaNode(
        colander.String(128),
        missing=None,
    )
