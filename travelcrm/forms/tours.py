# -*-coding: utf-8 -*-

import colander

from . import (
    Date,
    ResourceSchema,
)
from ..models.person import Person
from ..lib.utils.common_utils import cast_int
from ..lib.utils.common_utils import translate as _


@colander.deferred
def adults_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        if (value + int(cast_int(request.params.get('children')))) == 0:
            raise colander.Invalid(
                node,
                _(u'Adult or Children must be more than 0'),
            )
    return validator


@colander.deferred
def person_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        members_count = (
            int(cast_int(request.params.get('children')))
            + int(cast_int(request.params.get('adults')))
        )
        if len(value) < members_count:
            raise colander.Invalid(
                node,
                _(u'Members count must be %s') % members_count,
            )
    return validator


@colander.deferred
def customer_validator(node, kw):

    def validator(node, value):
        person = Person.get(value)
        if not person.contacts or not person.passports or not person.addresses:
            raise colander.Invalid(
                node,
                _(u'Customer must have contacts, passports and address')
            )
    return validator


class TourSchema(ResourceSchema):
    deal_date = colander.SchemaNode(
        Date()
    )
    customer_id = colander.SchemaNode(
        colander.Integer(),
        validator=customer_validator,
    )
    advsource_id = colander.SchemaNode(
        colander.Integer(),
    )
    touroperator_id = colander.SchemaNode(
        colander.Integer(),
    )
    price = colander.SchemaNode(
        colander.Money(),
    )
    adults = colander.SchemaNode(
        colander.Integer(),
        validator=adults_validator,
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
    start_date = colander.SchemaNode(
        Date()
    )
    end_date = colander.SchemaNode(
        Date()
    )
    tour_point_id = colander.SchemaNode(
        colander.Set(),
    )
    person_id = colander.SchemaNode(
        colander.Set(),
        validator=person_validator
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


class TourPointSchema(colander.Schema):
    location_id = colander.SchemaNode(
        colander.Integer(),
    )
    hotel_id = colander.SchemaNode(
        colander.Integer(),
        missing=None
    )
    accomodation_id = colander.SchemaNode(
        colander.Integer(),
        missing=None
    )
    foodcat_id = colander.SchemaNode(
        colander.Integer(),
        missing=None
    )
    roomcat_id = colander.SchemaNode(
        colander.Integer(),
        missing=None
    )
    start_date = colander.SchemaNode(
        Date()
    )
    end_date = colander.SchemaNode(
        Date()
    )
    description = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=255),
        missing=None
    )
