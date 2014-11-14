# -*-coding: utf-8 -*-

import colander

from . import ResourceSchema

from ..models.subaccount import Subaccount
from ..lib.bl.subaccounts import (
    get_subaccounts_types, 
    get_subaccount_by_source_id
)
from ..lib.utils.resources_utils import (
    get_resource_class, 
    get_resource_type_by_resource_cls
)
from ..lib.utils.common_utils import translate as _


@colander.deferred
def name_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        subaccount = Subaccount.by_name(value)
        if (
            subaccount
            and str(subaccount.id) != request.params.get('id')
        ):
            raise colander.Invalid(
                node,
                _(u'Subaccount with the same name exists'),
            )
    return colander.All(colander.Length(max=255), validator,)


def subaccount_type_validator(node, kw):
    return colander.OneOf(
        map(lambda x: x.name, get_subaccounts_types())
    )


@colander.deferred
def source_id_validator(node, kw):
    request = kw.get('request')
    
    def validator(node, value):
        resource_cls = get_resource_class(
            request.params.get('subaccount_type')
        )
        rt = get_resource_type_by_resource_cls(resource_cls)
        account_id = request.params.get('account_id') or 0
        subaccount = get_subaccount_by_source_id(
            value, rt.id, account_id
        )
        if (
            subaccount
            and str(subaccount.id) != request.params.get('id')
        ):
            raise colander.Invalid(
                node,
                _(u'Subaccount for this account already exists'),
            )
        
    return colander.All(validator,)


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
        validator=source_id_validator
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
