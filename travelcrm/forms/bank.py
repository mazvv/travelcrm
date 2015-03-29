# -*-coding: utf-8 -*-

import colander

from . import(
    ResourceSchema, 
    ResourceSearchSchema
)
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
    address_id = colander.SchemaNode(
        colander.Set(),
        missing=[],
    )

    def deserialize(self, cstruct):
        if (
            'address_id' in cstruct
            and not isinstance(cstruct.get('address_id'), list)
        ):
            val = cstruct['address_id']
            cstruct['address_id'] = list()
            cstruct['address_id'].append(val)
        return super(BankSchema, self).deserialize(cstruct)


class BankSearchSchema(ResourceSearchSchema):
    pass
