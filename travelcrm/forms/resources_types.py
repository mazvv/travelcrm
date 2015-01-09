# -*-coding: utf-8 -*-

import colander
import importlib

from . import ResourceSchema, ResourceSearchSchema
from ..models.resource_type import ResourceType
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


class ResourceTypeSchema(ResourceSchema):
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
    description = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=128),
        missing=u''
    )


class ResourceTypeSearchSchema(ResourceSearchSchema):
    pass
