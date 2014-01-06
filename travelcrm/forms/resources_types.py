# -*-coding: utf-8 -*-

import colander
import importlib

from . import ResourceForm
from ..models.resource_type import ResourceType


@colander.deferred
def resource_validator(node, kw):
    request = kw.get('request')
    _ = request.translate

    def validator(node, value):
        path = value.split('.')
        module, attr = '.'.join(path[:-1]), path[-1]
        try:
            mod = importlib.import_module(module)
            if not hasattr(mod, attr):
                raise colander.Invalid(_(u"Resource does not exist"))
        except ImportError:
            raise colander.Invalid(_(u"Resource module does not exist"))
        except:
            raise colander.Invalid(_(u"Check module name"))
    return colander.All(colander.Length(max=128), validator,)


@colander.deferred
def name_validator(node, kw):
    request = kw.get('request')
    _ = request.translate

    def validator(node, value):
        resource_type = ResourceType.by_name(value)
        if (
            resource_type
            and str(resource_type._resources_rid) != request.params.get('rid')
        ):
            raise colander.Invalid(
                node,
                _(u'Resource Type with the same name exists'),
            )
    return colander.All(colander.Length(max=128), validator,)


@colander.deferred
def humanize_validator(node, kw):
    request = kw.get('request')
    _ = request.translate

    def validator(node, value):
        resource_type = ResourceType.by_humanize(value)
        if (
            resource_type
            and str(resource_type._resources_rid) != request.params.get('rid')
        ):
            raise colander.Invalid(
                node,
                _(u'Resource Type with the same humanize exists'),
            )
    return colander.All(colander.Length(max=128), validator,)


class AddForm(ResourceForm):
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
    description = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=128),
        missing=u''
    )


class EditForm(AddForm):
    pass
