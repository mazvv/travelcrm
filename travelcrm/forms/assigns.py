# -*-coding: utf-8 -*-

import colander

from . import (
    SelectInteger,
    ResourceSchema,
    BaseForm,
)
from ..models.employee import Employee
from ..lib.utils.common_utils import translate as _
from ..lib.bl.employees import (
    get_employee_position,
    is_employee_currently_dismissed
)


@colander.deferred
def maintainer_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        employee = Employee.get(value)
        if request.params.get('employee_id') == str(value):
            raise colander.Invalid(
                node,
                _(u'Select another employee.')
            )
        if is_employee_currently_dismissed(employee):
            raise colander.Invalid(
                node,
                _(u'Employee is dismissed.')
            )
        if not get_employee_position(employee):
            raise colander.Invalid(
                node,
                _(u'Can\'t assign resources to employee without position.')
            )
    return validator


class _AssignsSchema(ResourceSchema):
    employee_id = colander.SchemaNode(
        SelectInteger(Employee),
    )
    maintainer_id = colander.SchemaNode(
        SelectInteger(Employee),
        validator=maintainer_validator
    )


class AssignForm(BaseForm):
    _schema = _AssignsSchema
    
    def submit(self):
        return (
            self._controls['employee_id'],
            self._controls['maintainer_id']
        )
