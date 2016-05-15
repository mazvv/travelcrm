# -*coding: utf-8-*-

from collections import Iterable

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.employee import Employee
from ...models.dismissal import Dismissal


class DismissalsQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(DismissalsQueryBuilder, self).__init__(context)
        self._fields = {
            'id': Dismissal.id,
            '_id': Dismissal.id,
            'date': Dismissal.date,
            'employee_name': Employee.name,
        }
        self._simple_search_fields = [
            Employee.first_name,
            Employee.last_name,
        ]

        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = (
            self.query
            .join(Dismissal, Resource.dismissal)
            .join(Employee, Dismissal.employee)
        )
        super(DismissalsQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Dismissal.id.in_(id))
