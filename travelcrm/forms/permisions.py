# -*-coding: utf-8 -*-

import colander

from ..lib.utils.common_utils import translate as _


class PermisionSchema(colander.Schema):
    position_id = colander.SchemaNode(
        colander.Integer(),
    )
    resource_type_id = colander.SchemaNode(
        colander.Integer(),
    )
    scope_type = colander.SchemaNode(
        colander.String(),
    )
    structure_id = colander.SchemaNode(
        colander.Integer(),
        missing=None
    )
    permisions = colander.Set()


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


class PermisionCopySchema(colander.Schema):
    position_id = colander.SchemaNode(
        colander.Integer()
    )
    from_position_id = colander.SchemaNode(
        colander.Integer(),
        validator=position_validator
    )
