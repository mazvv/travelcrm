# -*-coding: utf-8 -*-

import colander
import importlib

from . import (
    ResourceSchema, 
    BaseForm, 
    BaseSearchForm,
)
from ..resources.resource_type import ResourceTypeResource
from ..models.resource_type import ResourceType
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.resource_type import ResourceTypeQueryBuilder
from ..lib.utils.common_utils import translate as _


@colander.deferred
def resource_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        path = value.split('.')
        module, attr = '.'.join(path[:-1]), path[-1]
        try:
            mod = importlib.import_module(module)
            if not hasattr(mod, attr):
                raise colander.Invalid(node, _(u"Resource does not exist"))
        except ImportError:
            raise colander.Invalid(node, _(u"Resource module does not exist"))
        except:
            raise colander.Invalid(node, _(u"Check module name"))

        resource_type = ResourceType.by_resource_name(module, attr)
        if (
            resource_type
            and (
                str(resource_type.id) != request.params.get('id')
                or (
                    str(resource_type.id) == request.params.get('id')
                    and request.view_name == 'copy'
                )
            )
        ):
            raise colander.Invalid(
                node,
                _(u'Resource Type with the same resource exists'),
            )

    return colander.All(colander.Length(max=128), validator,)


@colander.deferred
def name_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        resource_type = ResourceType.by_name(value)
        if (
            resource_type
            and (
                str(resource_type.id) != request.params.get('id')
                or (
                    str(resource_type.id) == request.params.get('id')
                    and request.view_name == 'copy'
                )
            )
        ):
            raise colander.Invalid(
                node,
                _(u'Resource Type with the same name exists'),
            )
    return colander.All(colander.Length(max=128), validator,)


@colander.deferred
def humanize_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        resource_type = ResourceType.by_humanize(value)
        if (
            resource_type
            and (
                str(resource_type.id) != request.params.get('id')
                or (
                    str(resource_type.id) == request.params.get('id')
                    and request.view_name == 'copy'
                )
            )
        ):
            raise colander.Invalid(
                node,
                _(u'Resource Type with the same humanize exists'),
            )
    return colander.All(colander.Length(max=128), validator,)


class _ResourceTypeSchema(ResourceSchema):
    humanize = colander.SchemaNode(
        colander.String(),
        validator=humanize_validator
    )
    name = colander.SchemaNode(
        colander.String(),
        validator=name_validator
    )
    resource = colander.SchemaNode(
        colander.String(),
        validator=resource_validator
    )
    customizable = colander.SchemaNode(
        colander.Boolean(false_choices=("", "0", "false"), true_choices=("1")),
        missing=False,
    )
    descr = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=255),
        missing=u''
    )
    status = colander.SchemaNode(
        colander.String(),
    )


class ResourceTypeForm(BaseForm):
    _schema = _ResourceTypeSchema

    def submit(self, resource_type=None):
        context = ResourceTypeResource(self.request)
        if not resource_type:
            resource_type = ResourceType(
                resource_obj=context.create_resource()
            )
        else:
            resource_type.resource_obj.notes = []
            resource_type.resource_obj.tasks = []
        resource_type.humanize = self._controls.get('humanize')
        resource_type.name = self._controls.get('name')
        resource_type.resource = self._controls.get('resource')
        resource_type.customizable = self._controls.get('customizable')
        resource_type.descr = self._controls.get('descr')
        resource_type.status = self._controls.get('status')
        for id in self._controls.get('note_id'):
            note = Note.get(id)
            resource_type.resource_obj.notes.append(note)
        for id in self._controls.get('task_id'):
            task = Task.get(id)
            resource_type.resource_obj.tasks.append(task)
        return resource_type

class ResourceTypeSearchForm(BaseSearchForm):
    _qb = ResourceTypeQueryBuilder
