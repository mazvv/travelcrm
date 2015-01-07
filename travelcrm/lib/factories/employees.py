# -*coding: utf-8-*-

from ...models import DBSession
from ...models.resource import Resource
from ...models.employee import Employee
from ...models.subaccount import Subaccount
from ...lib.factories import SubaccountFactory


class EmployeeSubaccountFactory(SubaccountFactory):

    @classmethod
    def query_list(cls):
        query = (
            DBSession.query(
                Resource.id.label('resource_id'),
                Employee.id.label('id'),
                Employee.name.label('title'),
                Subaccount.name.label('name'),
                Subaccount.id.label('subaccount_id'),
            )
            .join(Resource, Employee.resource)
            .join(Subaccount, Employee.subaccounts)
        )
        return query

    @classmethod
    def get_source_resource(cls, id):
        employee = Employee.get(id)
        return employee.resource

    @classmethod
    def bind_subaccount(cls, resource_id, subaccount):
        assert isinstance(subaccount, Subaccount)
        employee = (
            DBSession.query(Employee)
            .filter(Employee.resource_id == resource_id)
            .first()
        )
        employee.subaccounts.append(subaccount)
        return employee
