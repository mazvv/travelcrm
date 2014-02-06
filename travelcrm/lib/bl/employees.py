# -*coding: utf-8-*-

from sqlalchemy import desc

from ...models import DBSession
from ...models.employee import Employee
from ...models.employee_appointment import (
    EmployeeAppointmentH,
    EmployeeAppointmentR
)
from ...models.position_permision import PositionPermision
from ...models.company import Company
from ...models.company_struct import CompanyStruct
from ...models.company_position import CompanyPosition
from ..utils.resources_utils import get_resource_type_by_resource


def get_employee_position(employee, date=None):
    assert isinstance(employee, Employee), type(employee)
    query = (
        DBSession.query(CompanyPosition)
        .join(EmployeeAppointmentR, CompanyPosition.employees_appointments)
        .join(EmployeeAppointmentH, EmployeeAppointmentR.header)
        .filter(EmployeeAppointmentR.condition_employee_id(employee.id))
    )
    if date:
        query = query.filter(
            EmployeeAppointmentH.appointment_date <= date
        )
    query = query.order_by(desc(EmployeeAppointmentH.appointment_date))
    return query.first()


def get_employee_permisions(employee, resource):
    """retrieve permissions for resource
    """
    rt = get_resource_type_by_resource(resource)
    employee_position = get_employee_position(employee)
    permisions = (
        employee_position.permisions.filter(
            PositionPermision.condition_resource_type_id(rt.id)
        )
        .first()
    )
    return permisions


def query_employee_scope(employee, resource):
    permisions = get_employee_permisions(employee, resource)
    if (
        permisions.scope_type == 'company'
        and not permisions.companies_structures_id
    ):
        company_position = permisions.company_position
        company = company_position.company_struct.company
        # TODO: check logic if user has new appointment
        return (
            DBSession.query(EmployeeAppointmentR.employee_id)
            .join(CompanyPosition, EmployeeAppointmentR.company_position)
            .join(CompanyStruct, CompanyPosition.company_struct)
            .join(Company, CompanyStruct.company)
            .filter(Company.id == company.id)
        )
    elif(
        permisions.scope_type == 'company'
        and permisions.companies_structures_id
    ):
        company_struct = permisions.company_position.company_struct
        return (
            DBSession.query(EmployeeAppointmentR.employee_id)
            .join(CompanyPosition, EmployeeAppointmentR.company_position)
            .join(CompanyStruct, CompanyPosition.company_struct)
            .filter(
                CompanyStruct.id.in_(
                    [item.id for item in company_struct.get_all_descendants()]
                )
            )
        )
    else:
        return None
