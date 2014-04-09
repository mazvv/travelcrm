# -*-coding: utf-8 -*-

import colander

from . import (
    ResourceSchema,
    DateTime,
)
from ..lib.utils.common_utils import cast_int


@colander.deferred
def adult_validator(node, kw):
    request = kw.get('request')
    _ = request.translate

    def validator(node, value):
        if (value + int(cast_int(request.params.get('children')))) == 0:
            raise colander.Invalid(
                node,
                _(u'Adult or Children must be more than 0'),
            )
    return validator


class TourDealSchema(ResourceSchema):
    touroperator_id = colander.SchemaNode(
        colander.Integer(),
    )
    price = colander.SchemaNode(
        colander.Decimal(),
    )
    adults = colander.SchemaNode(
        colander.Integer(),
        validator=adult_validator
    )
    children = colander.SchemaNode(
        colander.Integer(),
    )
    currency_id = colander.SchemaNode(
        colander.Integer(),
    )
    start_location_id = colander.SchemaNode(
        colander.Integer(),
    )
    end_location_id = colander.SchemaNode(
        colander.Integer(),
    )
    start_dt = colander.SchemaNode(
        DateTime()
    )
    end_dt = colander.SchemaNode(
        DateTime()
    )
    tour_point_id = colander.SchemaNode(
        colander.Set(),
    )
    person_id = colander.SchemaNode(
        colander.Set(),
    )

    def deserialize(self, cstruct):
        if (
            'tour_point_id' in cstruct
            and not isinstance(cstruct.get('tour_point_id'), list)
        ):
            val = cstruct['tour_point_id']
            cstruct['tour_point_id'] = list()
            cstruct['tour_point_id'].append(val)

        if (
            'person_id' in cstruct
            and not isinstance(cstruct.get('person_id'), list)
        ):
            val = cstruct['person_id']
            cstruct['person_id'] = list()
            cstruct['person_id'].append(val)

        return super(TourSchema, self).deserialize(cstruct)
