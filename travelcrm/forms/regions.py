# -*-coding: utf-8 -*-

import colander

from . import ResourceSchema


@colander.deferred
def parent_validator(node, kw):
    request = kw.get('request')
    _ = request.translate

    def validator(node, value):
        if request.params.get('id') and str(value) == request.params.get('id'):
            raise colander.Invalid(
                node,
                _(u'Can not be parent of self'),
            )
    return validator


class RegionSchema(ResourceSchema):
    parent_id = colander.SchemaNode(
        colander.Integer(),
        missing=None,
        validator=parent_validator
    )
    name = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=128)
    )
