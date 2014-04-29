# -*-coding: utf-8 -*-

import colander

from . import ResourceSchema
from ..models import DBSession
from ..models.position import Position
from ..lib.utils.common_utils import translate as _


@colander.deferred
def name_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        position = (
            DBSession.query(Position)
            .filter(
                Position.name == value,
                Position.structure_id == request.params.get('structure_id')
            )
            .first()
        )
        if (
            position
            and (
                str(position.id) != request.params.get('id')
                or (
                    str(position.id) == request.params.get('id')
                    and request.view_name == 'copy'
                )
            )
        ):
            raise colander.Invalid(
                node,
                _(u'Position with the same name for structure exists'),
            )
    return colander.All(colander.Length(max=128), validator,)


class PositionSchema(ResourceSchema):
    structure_id = colander.SchemaNode(
        colander.Integer(),
    )
    name = colander.SchemaNode(
        colander.String(),
        validator=name_validator
    )
