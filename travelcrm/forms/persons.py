# -*-coding: utf-8 -*-

import colander

from . import (
    ResourceSchema,
    Date
)


class PersonSchema(ResourceSchema):
    first_name = colander.SchemaNode(
        colander.String(),
    )
    last_name = colander.SchemaNode(
        colander.String(),
        missing=u""
    )
    second_name = colander.SchemaNode(
        colander.String(),
        missing=u""
    )
    gender = colander.SchemaNode(
        colander.String(),
        validators=colander.OneOf([u'male', u'female']),
        missing=None,
    )
    birthday = colander.SchemaNode(
        Date(),
        missing=None,
    )
    contact_id = colander.SchemaNode(
        colander.Set(),
        missing=[],
    )
    passport_id = colander.SchemaNode(
        colander.Set(),
        missing=[],
    )
    address_id = colander.SchemaNode(
        colander.Set(),
        missing=[],
    )

    def deserialize(self, cstruct):
        if (
            'address_id' in cstruct
            and not isinstance(cstruct.get('address_id'), list)
        ):
            val = cstruct['address_id']
            cstruct['address_id'] = list()
            cstruct['address_id'].append(val)
        if (
            'contact_id' in cstruct
            and not isinstance(cstruct.get('contact_id'), list)
        ):
            val = cstruct['contact_id']
            cstruct['contact_id'] = list()
            cstruct['contact_id'].append(val)
        if (
            'passport_id' in cstruct
            and not isinstance(cstruct.get('passport_id'), list)
        ):
            val = cstruct['passport_id']
            cstruct['passport_id'] = list()
            cstruct['passport_id'].append(val)

        return super(PersonSchema, self).deserialize(cstruct)
