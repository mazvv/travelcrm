# -*coding: utf-8-*-

from ...lib.utils.resources_utils import get_resource_class
from ...lib.bl.factories import get_liabilities_factories_resources_types
from ...models.resource import Resource
from ...models.liability import Liability


def query_resource_data():
    factories = get_liabilities_factories_resources_types()
    res = None
    for i, factory in enumerate(factories):
        if not i:
            res = factory.query_list()
        else:
            res = res.union(factory.query_list())
    return res


def get_bound_resource_by_liability_id(liability_id):
    bound_resource = (
        query_resource_data()
        .filter(Liability.id == liability_id)
        .first()
    )
    return Resource.get(bound_resource.resource_id)


def get_factory_by_liability_id(liability_id):
    resource = get_bound_resource_by_liability_id(liability_id)
    source_cls = get_resource_class(resource.resource_type.name)
    factory = source_cls.get_liability_factory()
    return factory
