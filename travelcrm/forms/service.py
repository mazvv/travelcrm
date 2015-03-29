# -*-coding: utf-8 -*-

import colander

from . import(
    ResourceSchema, 
    ResourceSearchSchema
)
from ..models.service import Service
from ..lib.utils.common_utils import translate as _


@colander.deferred
def name_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        service = Service.by_name(value)
        if (
            service
            and str(service.id) != request.params.get('id')
        ):
            raise colander.Invalid(
                node,
                _(u'Service with the same name exists'),
            )
    return colander.All(colander.Length(max=255), validator,)


class ServiceSchema(ResourceSchema):
    name = colander.SchemaNode(
        colander.String(),
        validator=name_validator,
    )
    account_item_id = colander.SchemaNode(
        colander.Integer(),
    )
    display_text = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=256),
        missing=None
    )
    resource_type_id = colander.SchemaNode(
        colander.Integer(),
    )
    descr = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=256),
        missing=None
    )


class ServiceSearchSchema(ResourceSearchSchema):
    pass
