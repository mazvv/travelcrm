# -*-coding: utf-8 -*-

import colander

from . import (
    SelectInteger,
    ResourceSchema,
    BaseForm,
    BaseSearchForm,
    BaseAssignForm,
    Date
)
from ..resources.dismissals import DismissalsResource
from ..models.dismissal import Dismissal
from ..models.employee import Employee
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.dismissals import DismissalsQueryBuilder
from ..lib.utils.common_utils import translate as _
from ..lib.utils.security_utils import get_auth_employee
from ..lib.bl.employees import (
    get_employee_position,
    is_employee_currently_dismissed
)


@colander.deferred
def employee_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        employee = Employee.get(value)
        if is_employee_currently_dismissed(employee):
            raise colander.Invalid(
                node,
                _(u'Employee is dismissed already.')
            )
        if not get_employee_position(employee):
            raise colander.Invalid(
                node,
                _(u'Can\'t dismiss employee without position.')
            )
    return validator


class _DismissalSchema(ResourceSchema):
    date = colander.SchemaNode(
        Date(),
    )
    employee_id = colander.SchemaNode(
        SelectInteger(Employee),
        validator=employee_validator,
    )


class DismissalForm(BaseForm):
    _schema = _DismissalSchema

    def submit(self, dismissal=None):
        if not dismissal:
            dismissal = Dismissal(
                resource=DismissalsResource.create_resource(
                    get_auth_employee(self.request)
                )
            )
        else:
            dismissal.resource.notes = []
            dismissal.resource.tasks = []
        dismissal.date = self._controls.get('date')
        dismissal.employee_id = self._controls.get('employee_id')
        for id in self._controls.get('note_id'):
            note = Note.get(id)
            dismissal.resource.notes.append(note)
        for id in self._controls.get('task_id'):
            task = Task.get(id)
            dismissal.resource.tasks.append(task)
        return dismissal


class DismissalSearchForm(BaseSearchForm):
    _qb = DismissalsQueryBuilder


class DismissalAssignForm(BaseAssignForm):
    def submit(self, ids):
        for id in ids:
            dismissal = Dismissal.get(id)
            dismissal.resource.maintainer_id = self._controls.get(
                'maintainer_id'
            )
