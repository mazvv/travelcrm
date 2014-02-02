# -*coding: utf-8-*-

from sqlalchemy import desc

from . import ResourcesQueryBuilder

from ...models import DBSession
from ...models.resource import Resource
from ...models.employee import Employee
from ...models.employee_appointment import (
    EmployeeAppointmentH,
    EmployeeAppointmentR
)
from ...models.company_position import CompanyPosition
from ...models.position_permision import PositionPermision

from .users import get_auth_user
from ..resources_utils import get_resource_type_by_resource


class EmployeesQueryBuilder(ResourcesQueryBuilder):
    _fields = {
        'id': Employee.id,
        '_id': Employee.id,
        'first_name': Employee.first_name,
        'last_name': Employee.last_name,
        'name': Employee.name
    }

    def __init__(self):
        super(EmployeesQueryBuilder, self).__init__()
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = self.query.join(Employee, Resource.employee)
        self.query = self.query.add_columns(*fields)


def get_auth_employee(request):
    user = get_auth_user(request)
    if user:
        return user.employee


def get_employee_position(employee, date=None):
    """ get employee position by date
    if date not given, return current position
    """
    assert isinstance(employee, Employee), type(employee)
    company_position = (
        DBSession.query(CompanyPosition)
        .join(EmployeeAppointmentR, CompanyPosition.employees_appointments)
        .join(EmployeeAppointmentH, EmployeeAppointmentR.header)
        .filter(EmployeeAppointmentR.condition_employee_id(employee.id))
        .order_by(desc(EmployeeAppointmentH.appointment_date))
        .first()
    )
    return company_position


def get_employee_permisions(employee, resource):
    """retrieve permissions for resource
    """
    rt = get_resource_type_by_resource(resource)
    employee_position = get_employee_position(employee)
    permisions = (
        employee_position.permisions.filter(
            PositionPermision.condition_resource_type_id(rt.id)
        )
        .with_entities(PositionPermision.permisions)
        .scalar()
    )
    return permisions
