# -*-coding: utf-8 -*-

import colander

from . import (
    SelectInteger,
    CSRFSchema,
    ResourceSchema,
    BaseForm,
    BaseSearchForm,
    BaseAssignForm,
)
from ..resources.users import UsersResource
from ..models.user import User
from ..models.employee import Employee
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.users import UsersQueryBuilder
from ..lib.utils.common_utils import translate as _
from ..lib.utils.security_utils import get_auth_employee


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
def email_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        user = User.by_email(value)
        if (
            user
            and str(user.id) != request.params.get('id')
        ):
            raise colander.Invalid(
                node,
                _(u'User with the same email exists'),
            )
    return colander.All(colander.Email(), validator,)


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


class _UserAddSchema(ResourceSchema):
    username = colander.SchemaNode(
        colander.String(),
        validator=username_validator
    )
    email = colander.SchemaNode(
        colander.String(),
        validator=email_validator
    )
    password = colander.SchemaNode(
        colander.String(),
        validator=password_validator
    )
    employee_id = colander.SchemaNode(
        SelectInteger(Employee),
        validator=employee_validator
    )


class _UserEditSchema(_UserAddSchema):
    password = colander.SchemaNode(
        colander.String(),
        missing=None,
        validator=password_validator
    )
    password_confirm = colander.SchemaNode(
        colander.String(),
        missing=None
    )


class _UserProfileSchema(CSRFSchema):
    password = colander.SchemaNode(
        colander.String(),
        missing=None,
        validator=password_validator
    )
    password_confirm = colander.SchemaNode(
        colander.String(),
        missing=None
    )


class _UserForm(BaseForm):

    def submit(self, user=None):
        if not user:
            user = User(
                resource=UsersResource.create_resource(
                    get_auth_employee(self.request)
                )
            )
        else:
            user.resource.notes = []
            user.resource.tasks = []
        user.username = self._controls.get('username')
        user.email = self._controls.get('email')
        user.employee_id = self._controls.get('employee_id')
        if self._controls.get('password'):
            user.password = self._controls.get('password')
        for id in self._controls.get('note_id'):
            note = Note.get(id)
            user.resource.notes.append(note)
        for id in self._controls.get('task_id'):
            task = Task.get(id)
            user.resource.tasks.append(task)
        return user


class UserAddForm(_UserForm):
    _schema = _UserAddSchema


class UserEditForm(_UserForm):
    _schema = _UserEditSchema


class UserProfileForm(BaseForm):
    _schema = _UserProfileSchema

    def submit(self, user):
        if self._controls.get('password'):
            user.password = self._controls.get('password')
        return user


class UserSearchForm(BaseSearchForm):
    _qb = UsersQueryBuilder


class UserAssignForm(BaseAssignForm):
    def submit(self, ids):
        for id in ids:
            user = User.get(id)
            user.resource.maintainer_id = self._controls.get(
                'maintainer_id'
            )
