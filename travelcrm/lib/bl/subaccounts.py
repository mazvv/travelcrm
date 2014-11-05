# -*coding: utf-8-*-

from ...interfaces import ISubaccountFactory

from ...models.resource import Resource
from ...models.subaccount import Subaccount

from ...lib.utils.resources_utils import get_resources_types_by_interface
from ...lib.bl.factories import get_subaccounts_factories_resources_types
from ...lib.utils.resources_utils import get_resource_class
from ...lib.utils.sql_utils import build_union_query


def get_subaccounts_types():
    return get_resources_types_by_interface(ISubaccountFactory)


def query_resource_data():
    factories = get_subaccounts_factories_resources_types()
    queries = [factory.query_list() for factory in factories]
    return build_union_query(queries)


def get_bound_resource_by_subaccount_id(subaccount_id):
    bound_resource = (
        query_resource_data()
        .filter(Subaccount.id == subaccount_id)
        .first()
    )
    return Resource.get(bound_resource.resource_id)


def get_factory_by_subaccount_id(subaccount_id):
    resource = get_bound_resource_by_subaccount_id(subaccount_id)
    source_cls = get_resource_class(resource.resource_type.name)
    factory = source_cls.get_invoice_factory()
    return factory
