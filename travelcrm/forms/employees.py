# -*-coding: utf-8 -*-

import colander
from webhelpers.number import format_data_size
from . import (
    ResourceSchema,
    Date,
    File,
)
from ..lib.utils.common_utils import translate as _
from pyramid_storage.extensions import IMAGES


UPLOAD_MAX_SIZE = 102400


@colander.deferred
def photo_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        if len(value.file.read()) > UPLOAD_MAX_SIZE:
            raise colander.Invalid(
                node,
                _(u'Max Image Size for Upload is %s')
                % format_data_size(UPLOAD_MAX_SIZE, 'B', 2),
            )
        try:
            request.storage.file_allowed(value, IMAGES)
        except:
            raise colander.Invalid(
                node,
                _(u'Only images allowed'),
            )
        value.file.seek(0)

    return validator


class EmployeeSchema(ResourceSchema):
    photo = colander.SchemaNode(
        File(),
        missing=None,
        validator=photo_validator
    )
    delete_photo = colander.SchemaNode(
        colander.Boolean(),
        missing=False,
    )
    first_name = colander.SchemaNode(
        colander.String(),
    )
    last_name = colander.SchemaNode(
        colander.String(),
    )
    second_name = colander.SchemaNode(
        colander.String(),
        missing=None
    )
    itn = colander.SchemaNode(
        colander.String(),
        missing=None,
        validator=colander.Length(min=2, max=32)
    )
    dismissal_date = colander.SchemaNode(
        Date(),
        missing=None
    )
    contact_id = colander.SchemaNode(
        colander.Set(),
        missing=[]
    )
    passport_id = colander.SchemaNode(
        colander.Set(),
        missing=[]
    )
    address_id = colander.SchemaNode(
        colander.Set(),
        missing=[]
    )

    def deserialize(self, cstruct):
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

        if (
            'address_id' in cstruct
            and not isinstance(cstruct.get('address_id'), list)
        ):
            val = cstruct['address_id']
            cstruct['address_id'] = list()
            cstruct['address_id'].append(val)

        return super(EmployeeSchema, self).deserialize(cstruct)
