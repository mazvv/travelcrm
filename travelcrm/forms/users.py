# -*-coding: utf-8 -*-

import colander

from . import (
    ResourceSchema,
    ResourceSearchSchema
)
from ..models.user import User
from ..lib.utils.common_utils import translate as _


@colander.deferred
def username_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        user = User.by_username(value)
        if (
            user
            and str(user.id) != request.params.get('id')
        ):
            raise colander.Invalid(
                node,
                _(u'User with the same username exists'),
            )
    return colander.All(colander.Length(max=32), validator,)


@colander.deferred
def employee_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        user = User.by_employee_id(value)
        if (
            user
            and str(user.id) != request.params.get('id')
        ):
            raise colander.Invalid(
                node,
                _(u'User for this employee already exists'),
            )
    return colander.All(validator,)


@colander.deferred
def password_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        if value and request.params.get('password_confirm') != value:
            raise colander.Invalid(
                node,
                _(u'Password and confirm is not equal'),
            )
    return colander.All(colander.Length(min=6, max=128), validator,)


class UserAddSchema(ResourceSchema):
    username = colander.SchemaNode(
        colander.String(),
        validator=username_validator
    )
    password = colander.SchemaNode(
        colander.String(),
        validator=password_validator
    )
    employee_id = colander.SchemaNode(
        colander.Integer(),
        validator=employee_validator
    )


class UserEditSchema(UserAddSchema):
    password = colander.SchemaNode(
        colander.String(),
        missing=None,
        validator=password_validator
    )
    password_confirm = colander.SchemaNode(
        colander.String(),
        missing=None
    )


class UserSearchSchema(ResourceSearchSchema):
    pass
