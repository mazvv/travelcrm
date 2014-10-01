# -*-coding: utf-8 -*-

import colander

from . import ResourceSchema
from ..models.account_item import AccountItem
from ..lib.utils.common_utils import translate as _


@colander.deferred
def name_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        account_item = AccountItem.by_name(value)
        if (
            account_item
            and str(account_item.id) != request.params.get('id')
        ):
            raise colander.Invalid(
                node,
                _(u'Account Item with the same name exists'),
            )
    return colander.All(colander.Length(max=255), validator,)


class AccountItemSchema(ResourceSchema):
    name = colander.SchemaNode(
        colander.String(),
        validator=name_validator,
    )
