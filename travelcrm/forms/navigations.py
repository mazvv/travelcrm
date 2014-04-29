# -*-coding: utf-8 -*-

import colander

from . import ResourceSchema
from ..lib.utils.common_utils import translate as _


@colander.deferred
def parent_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        if request.params.get('id') and str(value) == request.params.get('id'):
            raise colander.Invalid(
                node,
                _(u'Can not be parent of self'),
            )
    return validator


class NavigationSchema(ResourceSchema):
    position_id = colander.SchemaNode(
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


@colander.deferred
def position_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        if value == int(request.params.get('position_id')):
            raise colander.Invalid(
                node,
                _(u'Can not copy to itself'),
            )
    return colander.All(validator,)


class NavigationCopySchema(colander.Schema):
    position_id = colander.SchemaNode(
        colander.Integer()
    )
    from_position_id = colander.SchemaNode(
        colander.Integer(),
        validator=position_validator
    )
