# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder

from ...models.resource import Resource
from ...models.employee import Employee
from ...lib.bl.employees import query_employees_dismissed


class EmployeesQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(EmployeesQueryBuilder, self).__init__(context)
        self._dismissal_subq = query_employees_dismissed().subquery()
        self._fields = {
            'id': Employee.id,
            '_id': Employee.id,
            'first_name': Employee.first_name,
            'last_name': Employee.last_name,
            'dismissal_date': self._dismissal_subq.c.date,
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
        self.query = (
            self.query
            .join(Employee, Resource.employee)
            .outerjoin(
                self._dismissal_subq,
                self._dismissal_subq.c.employee_id == Employee.id 
            )
        )
        super(EmployeesQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Employee.id.in_(id))
