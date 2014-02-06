# -*coding: utf-8-*-

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

    def __init__(self, context):
        super(UsersQueryBuilder, self).__init__(context)
        self.query = (
            self.query
            .join(User, Resource.user)
            .join(Employee, User.employee)
        )
        self._fields['username'] = User.username
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = self.query.add_columns(*fields)
