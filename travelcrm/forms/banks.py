# -*-coding: utf-8 -*-

import colander

from . import ResourceSchema
from ..models.bank import Bank
from ..lib.utils.common_utils import translate as _


@colander.deferred
def name_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        bank = Bank.by_name(value)
        if (
            bank
            and str(bank.id) != request.params.get('id')
        ):
            raise colander.Invalid(
                node,
                _(u'Bank with the same name exists'),
            )
    return colander.All(colander.Length(max=255), validator,)


class BankSchema(ResourceSchema):
    name = colander.SchemaNode(
        colander.String(),
        validator=name_validator,
    )
