# -*coding: utf-8-*-
import importlib

from zope.interface.verify import (
    verifyClass,
    DoesNotImplement
)

from ...models import DBSession
from ...models.resource_type import ResourceType


class ResourceClassNotFound(Exception):
    pass


class ResourceTypeNotFound(Exception):
    pass


def get_resource_class_module(cls):
    """ get module name by resource class
    """
    assert isinstance(cls, type), type(cls)
    return cls.__module__


def get_resource_class_name(cls):
    """ return resource class name
    """
    assert isinstance(cls, type), type(cls)
    return cls.__name__


def get_resource_class(key):
    """ get class by resource name

    retrieve class name and module name from DB and get glass from module
    """
    rt = ResourceType.by_name(key)
    try:
        rt_module = importlib.import_module(rt.module)
        resource = getattr(rt_module, rt.resource)
        return resource
    except:
        raise ResourceClassNotFound(key)


def get_resource_type_by_resource(resource):
    """retrieve resource type from DB by module and class name
    """
    return ResourceType.by_resource_name(
        resource.__class__.__module__,
        resource.__class__.__name__
    )


def get_resource_type_by_resource_cls(cls):
    """retrieve resource type from DB by module and class name
    """
    return ResourceType.by_resource_name(
        cls.__module__,
        cls.__name__
    )


def get_resources_types_by_interface(interface):
    """get all resources types that implements given interface
    """
    rts = DBSession.query(ResourceType)
    res = []
    for rt in rts:
        rt_cls = get_resource_class(rt.name)
        try:
            verifyClass(interface, rt_cls)
            res.append(rt)
        except DoesNotImplement:
            continue
    return res


def get_resource_settings(resource):
    """get resource settings by resource object
    """
    rt = get_resource_type_by_resource(resource)
    return rt.settings


def get_resource_settings_by_resource_cls(cls):
    """get resource settings by resource class
    """
    rt = get_resource_type_by_resource_cls(cls)
    return rt.settings
