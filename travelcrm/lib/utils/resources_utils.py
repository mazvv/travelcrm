# -*coding: utf-8-*-
import importlib

from ...models.resource_type import ResourceType


class ResourceClassNotFound(Exception):
    pass


class ResourceTypeNotFound(Exception):
    pass


class ResourceTypeIsNotActive(Exception):
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
    if rt and not rt.resource_obj.is_active():
        # TODO: make it more civilian
        raise ResourceTypeIsNotActive()
    try:
        rt_module = importlib.import_module(rt.module)
        resource = getattr(rt_module, rt.resource)
        return resource
    except:
        raise ResourceClassNotFound()


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
