# -*coding: utf-8-*-

from sqlalchemy.orm import aliased
from pyramid.security import authenticated_userid

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.user import User
from ...models.employee import Employee


class UsersQueryBuilder(ResourcesQueryBuilder):
    _fields = {
        'id': Employee.id,
        '_id': Employee.id,
        'employee_name': Employee.name,
    }

    def __init__(self):
        super(UsersQueryBuilder, self).__init__()
        aUser = aliased(User)
        self.query = (
            self.query
            .join(aUser, Resource.user)
            .join(Employee, aUser.employee)
        )
        self._fields['username'] = User.username
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = self.query.add_columns(*fields)


def get_auth_user(request):
    return User.get(authenticated_userid(request))
