# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.user import User
from ...models.employee import Employee


class UsersQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(UsersQueryBuilder, self).__init__(context)
        self._fields = {
            'id': User.id,
            '_id': User.id,
            'employee_name': Employee.name,
            'email': User.email,
            'username': User.username,
        }
        self._simple_search_fields = [
            Employee.name,
            Employee.first_name,
            Employee.last_name,
            User.username,
            User.email,
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = (
            self.query
            .join(User, Resource.user)
            .join(Employee, User.employee)
        )
        super(UsersQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(User.id.in_(id))
