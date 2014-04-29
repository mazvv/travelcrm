# -*coding: utf-8-*-

from types import ClassType

from sqlalchemy import desc

from ...models import DBSession
from ...models.employee import Employee
from ...models.appointment import Appointment
from ...models.permision import Permision
from ...models.structure import Structure
from ...models.position import Position
from ..utils.resources_utils import (
    get_resource_type_by_resource,
    get_resource_type_by_resource_cls
)


def get_employee_position(employee, date=None):
    assert isinstance(employee, Employee), type(employee)
    if employee.is_currently_dismissed():
        return None
    query = (
        DBSession.query(Position)
        .join(Appointment, Position.appointments)
        .filter(Appointment.condition_employee_id(employee.id))
    )
    if date:
        query = query.filter(
            Appointment.date <= date
        )
    query = query.order_by(desc(Appointment.date))
    return query.first()


def get_employee_structure(employee, date=None):
    position = get_employee_position(employee, date)
    if position:
        return position.structure


def get_employee_permisions(employee, resource):
    """retrieve permissions for resource
    resource can be instance of context or context class
    """
    if isinstance(resource, (type, ClassType)):
        rt = get_resource_type_by_resource_cls(resource)
    else:
        rt = get_resource_type_by_resource(resource)
    employee_position = get_employee_position(employee)
    permisions = (
        employee_position.permisions.filter(
            Permision.condition_resource_type_id(rt.id)
        )
        .first()
    )
    return permisions


def query_employee_scope(employee, resource):
    permisions = get_employee_permisions(employee, resource)
    if permisions.scope_type == 'all':
        return DBSession.query(Structure.id)
    elif(
        permisions.scope_type == 'structure'
        and permisions.structure_id
    ):
        structure = permisions.structure
        children_structures_ids = [
            item.id for item in structure.get_all_descendants()
        ]
        return (
            DBSession.query(Structure.id)
            .filter(Structure.id.in_(children_structures_ids))
        )
    else:
        # has any permissions
        return DBSession.query(Structure.id).filter(Structure.id == None)


def get_employee_last_appointment(employee_id):
    employee = Employee.get(employee_id)
    if employee:
        appointment = (
            employee.appointments.order_by(desc(Appointment.date)).first()
        )
        return appointment
