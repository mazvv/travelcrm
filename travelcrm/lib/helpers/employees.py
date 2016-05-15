# -*-coding: utf-8-*-

from ...lib.bl.employees import (
    get_employee_position as _get_employee_position,
    get_employee_structure as _get_employee_structure,
    is_employee_currently_dismissed as _is_employee_currently_dismissed
)


def get_employee_position(employee):
    return _get_employee_position(employee)


def get_employee_structure(employee):
    return _get_employee_structure(employee)


def is_employee_currently_dismissed(employee):
    return _is_employee_currently_dismissed(employee)
