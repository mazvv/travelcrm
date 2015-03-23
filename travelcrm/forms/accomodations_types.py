# -*-coding: utf-8 -*-

import colander

from . import(
    ResourceSchema, 
    ResourceSearchSchema
)
from ..models.accomodation_type import AccomodationType
from ..lib.utils.common_utils import translate as _


@colander.deferred
def name_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        accomodation_type = AccomodationType.by_name(value)
        if (
            accomodation_type
            and str(accomodation_type.id) != request.params.get('id')
        ):
            raise colander.Invalid(
                node,
                _(u'Room category with the same name exists'),
            )
    return colander.All(colander.Length(max=32), validator,)


class AccomodationTypeSchema(ResourceSchema):
    name = colander.SchemaNode(
        colander.String(),
        validator=name_validator,
    )


class AccomodationTypeSearchSchema(ResourceSearchSchema):
    pass
