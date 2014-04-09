# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder

from ...models.resource import Resource
from ...models.employee import Employee


class EmployeesQueryBuilder(ResourcesQueryBuilder):
    _fields = {
        'id': Employee.id,
        '_id': Employee.id,
        'first_name': Employee.first_name,
        'last_name': Employee.last_name,
        'name': Employee.name
    }

    _simple_search_fields = [
        Employee.first_name,
        Employee.last_name,
        Employee.name,
    ]

    def __init__(self, context):
        super(EmployeesQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = self.query.join(Employee, Resource.employee)
        self.query = self.query.add_columns(*fields)

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Employee.id.in_(id))
