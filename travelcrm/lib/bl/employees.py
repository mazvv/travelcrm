# -*coding: utf-8-*-

from types import ClassType
from datetime import datetime

from sqlalchemy import desc, func

from ...models import DBSession
from ...models.employee import Employee
from ...models.appointment import Appointment
from ...models.permision import Permision
from ...models.structure import Structure
from ...models.position import Position
from ...models.dismissal import Dismissal
from ..utils.resources_utils import (
    get_resource_type_by_resource,
    get_resource_type_by_resource_cls
)


def query_employees_dismissed():
    subq = (
        DBSession.query(Appointment.employee_id, Appointment.date)
        .distinct(Appointment.employee_id)
        .order_by(
            Appointment.employee_id, Appointment.date.desc()
        )
        .subquery()
    )
    return (
        DBSession.query(Dismissal.employee_id, Dismissal.date)
        .distinct(Dismissal.employee_id)
        .outerjoin(subq, Dismissal.employee_id == subq.c.employee_id)
        .filter(Dismissal.date > subq.c.date)
        .order_by(
            Dismissal.employee_id,
            Dismissal.date.desc()
        )
    )


def is_employee_currently_dismissed(employee):
    """check if employee is dismissed now
    """
    query = (
        query_employees_dismissed()
        .filter(
            Dismissal.employee_id == employee.id,
            Dismissal.date < datetime.now()
        )
    )
    return DBSession.query(query.exists()).scalar()


def query_employees_position(date=None):
    query = (
        DBSession.query(Position)
        .distinct(Appointment.employee_id)
        .join(Appointment, Position.appointments)
    )
    if date:
        query = query.filter(
            Appointment.date <= date
        )
    else:
        query = query.filter(
            Appointment.date <= func.now()
        )
    return query.order_by(Appointment.employee_id, desc(Appointment.date))


def get_employee_position(employee, date=None):
    """get employee position by date
    if date is None return current employee position
    """
    assert isinstance(employee, Employee), type(employee)
    if is_employee_currently_dismissed(employee):
        return None
    query = (
        query_employees_position(date)
        .filter(Appointment.condition_employee_id(employee.id))
    )
    return query.first()


def get_employee_structure(employee, date=None):
    """get employee structure by date
    if date is None return current employee structure
    """
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

    if not rt.is_active():
        return

    employee_position = get_employee_position(employee)
    permisions = (
        employee_position.permisions.filter(
            Permision.condition_resource_type_id(rt.id)
        )
        .first()
    )
    return permisions


def query_employee_scope(employee, resource):
    """get employee scope for resource
    resource can be instance of context or context class
    """
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
        children_structures_ids.append(permisions.structure_id)
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
