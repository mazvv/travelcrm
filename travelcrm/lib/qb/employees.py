# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder

from ...models.resource import Resource
from ...models.employee import Employee


class EmployeesQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(EmployeesQueryBuilder, self).__init__(context)
        self._fields = {
            'id': Employee.id,
            '_id': Employee.id,
            'first_name': Employee.first_name,
            'last_name': Employee.last_name,
            'dismissal_date': Employee.dismissal_date,
            'name': Employee.name,
        }
        self._simple_search_fields = [
            Employee.first_name,
            Employee.last_name,
            Employee.name,
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = self.query.join(
            Employee, Resource.employee
        )
        super(EmployeesQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Employee.id.in_(id))
