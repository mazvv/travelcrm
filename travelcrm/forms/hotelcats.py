# -*-coding: utf-8 -*-

import colander

from . import ResourceSchema

from ..models.hotelcat import Hotelcat
from ..lib.utils.common_utils import translate as _


@colander.deferred
def name_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        hotelcat = Hotelcat.by_name(value)
        if (
            hotelcat
            and str(hotelcat.id) != request.params.get('id')
        ):
            raise colander.Invalid(
                node,
                _(u'Hotel category with the same name exists'),
            )
    return colander.All(colander.Length(max=32), validator,)


class HotelcatSchema(ResourceSchema):
    name = colander.SchemaNode(
        colander.String(),
        validator=name_validator,
    )
