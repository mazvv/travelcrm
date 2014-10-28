# -*coding: utf-8-*-

from ...models.resource import Resource
from ...models.calculation import Calculation

from ...lib.bl.factories import get_calculations_factories_resources_types
from ...lib.utils.resources_utils import get_resource_class


def query_resource_data():
    factories = get_calculations_factories_resources_types()
    res = None
    for i, factory in enumerate(factories):
        if not i:
            res = factory.query_list()
        else:
            res = res.union(factory.query_list())
    return res


def get_bound_resource_by_calculation_id(calculation_id):
    bound_resource = (
        query_resource_data()
        .filter(Calculation.id == calculation_id)
        .first()
    )
    return Resource.get(bound_resource.resource_id)


def get_calculations_factory(resource_id):
    resource = Resource.get(resource_id)
    source_cls = get_resource_class(resource.resource_type.name)
    return source_cls.get_calculation_factory()


def get_resource_calculations(resource_id):
    factory = get_calculations_factory(resource_id)
    return factory.get_calculations(resource_id)


def get_resource_services_items(resource_id):
    factory = get_calculations_factory(resource_id)
    return factory.get_services_items(resource_id)


def get_calculation_date(resource_id):
    factory = get_calculations_factory(resource_id)
    return factory.get_date(resource_id)
