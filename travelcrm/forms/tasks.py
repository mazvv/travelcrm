# -*-coding: utf-8 -*-

from datetime import datetime
from pytz import timezone

import colander

from . import (
    ResourceSchema,
    ResourceSearchSchema,
    BaseForm,
    BaseSearchForm,
    BaseAssignForm,
    SelectInteger,
    DateTime
)
from ..resources.tasks import TasksResource
from ..models.upload import Upload
from ..models.employee import Employee
from ..models.task import Task
from ..models.note import Note
from ..lib.qb.tasks import TasksQueryBuilder
from ..lib.utils.security_utils import get_auth_employee
from ..lib.utils.common_utils import get_timezone
from ..lib.utils.common_utils import translate as _


@colander.deferred
def deadline_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        if (
            not Task.get(request.params.get('id'))
            and value <= datetime.now(tz=timezone(get_timezone()))
        ):
            raise colander.Invalid(
                node,
                _(u'Must be in the feature'),
            )
    return validator


class _TaskSchema(ResourceSchema):
    task_resource_id = colander.SchemaNode(
        colander.Integer(),
        missing=None,
    )
    title = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(min=2, max=128)
    )
    deadline = colander.SchemaNode(
        DateTime(),
        validator=deadline_validator
    )
    maintainer_id = colander.SchemaNode(
        SelectInteger(Employee),
    )
    reminder = colander.SchemaNode(
        colander.Integer(),
    )
    descr = colander.SchemaNode(
        colander.String(),
    )
    status = colander.SchemaNode(
        colander.String(),
    )
    upload_id = colander.SchemaNode(
        colander.Set(),
        missing=[]
    )

    def deserialize(self, cstruct):
        if (
            'upload_id' in cstruct
            and not isinstance(cstruct.get('upload_id'), list)
        ):
            val = cstruct['upload_id']
            cstruct['upload_id'] = list()
            cstruct['upload_id'].append(val)

        return super(_TaskSchema, self).deserialize(cstruct)


class TaskSearchSchema(ResourceSearchSchema):
    maintainer_id = colander.SchemaNode(
        colander.Integer(),
        missing=None,
    )
    status = colander.SchemaNode(
        colander.String(),
        missing=None
    )


class TaskForm(BaseForm):
    _schema = _TaskSchema

    def submit(self, task=None):
        if not task:
            task = Task(
                resource=TasksResource.create_resource(
                    get_auth_employee(self.request)
                )
            )
        else:
            task.uploads = []
            task.resource.notes = []
        task.resource.maintainer_id = self._controls.get(
            'maintainer_id'
        )
        task.title = self._controls.get('title')
        task.deadline = self._controls.get('deadline')
        task.reminder = self._controls.get('reminder')
        task.descr = self._controls.get('descr')
        task.status = self._controls.get('status')
        for id in self._controls.get('upload_id'):
            upload = Upload.get(id)
            task.uploads.append(upload)
        for id in self._controls.get('note_id'):
            note = Note.get(id)
            task.resource.notes.append(note)
        return task


class TaskSearchForm(BaseSearchForm):
    _schema = TaskSearchSchema
    _qb = TasksQueryBuilder


class TaskAssignForm(BaseAssignForm):
    def submit(self, ids):
        for id in ids:
            task = Task.get(id)
            task.resource.maintainer_id = self._controls.get(
                'maintainer_id'
            )
