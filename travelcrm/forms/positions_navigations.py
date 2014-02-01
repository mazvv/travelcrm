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


class PositionNavigationSchema(ResourceSchema):
    companies_positions_id = colander.SchemaNode(
        colander.Integer()
    )
    parent_id = colander.SchemaNode(
        colander.Integer(),
        missing=None,
        validator=parent_validator
    )
    name = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=128)
    )
    url = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=128)
    )
    icon_cls = colander.SchemaNode(
        colander.String(),
        missing=None,
        validator=colander.Length(max=32)
    )
