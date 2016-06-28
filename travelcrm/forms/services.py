# -*-coding: utf-8 -*-

import colander

from . import(
    SelectInteger,
    ResourceSchema, 
    BaseForm,
    BaseSearchForm,
    BaseAssignForm,
)
from ..resources.services import ServicesResource
from ..models.service import Service
from ..models.resource_type import ResourceType
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.services import ServicesQueryBuilder
from ..lib.utils.common_utils import translate as _
from ..lib.utils.security_utils import get_auth_employee


@colander.deferred
def name_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        service = Service.by_name(value)
        if (
            service
            and str(service.id) != request.params.get('id')
        ):
            raise colander.Invalid(
                node,
                _(u'Service with the same name exists'),
            )
    return colander.All(colander.Length(max=255), validator,)


class _ServiceSchema(ResourceSchema):
    name = colander.SchemaNode(
        colander.String(),
        validator=name_validator,
    )
    display_text = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=255),
    )
    resource_type_id = colander.SchemaNode(
        SelectInteger(ResourceType),
    )
    descr = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=255),
        missing=None
    )


class ServiceForm(BaseForm):
    _schema = _ServiceSchema

    def submit(self, service=None):
        if not service:
            service = Service(
                resource=ServicesResource.create_resource(
                    get_auth_employee(self.request)
                )
            )
        else:
            service.resource.notes = []
            service.resource.tasks = []
        service.name = self._controls.get('name')
        service.display_text = self._controls.get('display_text')
        service.resource_type_id = self._controls.get('resource_type_id')
        service.descr = self._controls.get('descr')
        for id in self._controls.get('note_id'):
            note = Note.get(id)
            service.resource.notes.append(note)
        for id in self._controls.get('task_id'):
            task = Task.get(id)
            service.resource.tasks.append(task)
        return service


class ServiceSearchForm(BaseSearchForm):
    _qb = ServicesQueryBuilder


class ServiceAssignForm(BaseAssignForm):
    def submit(self, ids):
        for id in ids:
            service = Service.get(id)
            service.resource.maintainer_id = self._controls.get(
                'maintainer_id'
            )
