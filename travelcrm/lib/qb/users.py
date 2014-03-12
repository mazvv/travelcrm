# -*coding: utf-8-*-

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.user import User
from ...models.employee import Employee


class UsersQueryBuilder(ResourcesQueryBuilder):
    _fields = {
        'id': User.id,
        '_id': User.id,
        'employee_name': Employee.name,
        'username': User.username,
    }

    _simple_search_fields = [
        Employee.name,
        Employee.first_name,
        Employee.last_name,
        User.username,
    ]

    def __init__(self, context):
        super(UsersQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = (
            self.query
            .join(User, Resource.user)
            .join(Employee, User.employee)
        )
        self.query = self.query.add_columns(*fields)
