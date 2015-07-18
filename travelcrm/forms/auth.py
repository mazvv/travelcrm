# -*-coding: utf-8 -*-

import colander

from . import (
    BaseForm,
)

from ..models.user import User
from ..lib.utils.common_utils import translate as _
from ..lib.scheduler.users import schedule_user_password_recovery


@colander.deferred
def email_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        user = User.by_email(value)
        if not user:
            raise colander.Invalid(
                node,
                _(u'Email does not exists'),
            )
    return colander.All(colander.Email(), validator)


class LoginSchema(colander.Schema):
    username = colander.SchemaNode(
        colander.String(),
        missing=u''
    )
    password = colander.SchemaNode(
        colander.String(),
        missing=u'',
    )


class _ForgotSchema(colander.Schema):
    email = colander.SchemaNode(
        colander.String(),
        validator=email_validator,
    )


class ForgotForm(BaseForm):
    _schema = _ForgotSchema

    def submit(self):
        user = User.by_email(self._controls.get('email'))
        if user:
            schedule_user_password_recovery(
                self.request,
                user.id,
            )
