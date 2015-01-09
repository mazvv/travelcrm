# -*-coding: utf-8 -*-

import colander

from . import ResourceSchema, ResourceSearchSchema
from ..models import DBSession
from ..models.location import Location
from ..lib.utils.common_utils import translate as _


@colander.deferred
def name_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        location = (
            DBSession.query(Location)
            .filter(
                Location.region_id == request.params.get('region_id'),
                Location.name == value
            )
            .first()
        )
        if (
            location
            and (
                str(location.id) != request.params.get('id')
                or (
                    str(location.id) == request.params.get('id')
                    and request.view_name == 'copy'
                )
            )
        ):
            raise colander.Invalid(
                node,
                _(u'Location with the same name exists'),
            )
    return colander.All(colander.Length(max=128), validator,)


class LocationSchema(ResourceSchema):
    region_id = colander.SchemaNode(
        colander.Integer(),
    )
    name = colander.SchemaNode(
        colander.String(),
        validator=name_validator
    )


class LocationSearchSchema(ResourceSearchSchema):
    pass
