# -*-coding: utf-8 -*-

import colander

from . import ResourceSchema
from ..models import DBSession
from ..models.region import Region
from ..lib.utils.common_utils import translate as _


@colander.deferred
def name_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        region = (
            DBSession.query(Region).filter(
                Region.name == value,
                Region.country_id == request.params.get('country_id')
            ).first()
        )
        if (
            region
            and str(region.id) != request.params.get('id')
        ):
            raise colander.Invalid(
                node,
                _(u'Region already exists'),
            )
    return colander.All(colander.Length(max=128), validator,)


class RegionSchema(ResourceSchema):
    country_id = colander.SchemaNode(
        colander.Integer(),
    )
    name = colander.SchemaNode(
        colander.String(),
        validator=name_validator
    )
