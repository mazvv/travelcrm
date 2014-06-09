# -*coding: utf-8-*-
from inspect import isfunction

from ...interfaces import IInvoiceFactory

from ...lib.utils.resources_utils import (
    get_resources_types_by_interface,
    get_resource_class
)
from ...models.invoice import Invoice
from ...models.resource import Resource


def get_invoices_factories_resources_types():
    factories = []
    for rt in get_resources_types_by_interface(IInvoiceFactory):
        rt_cls = get_resource_class(rt.name)
        assert isfunction(rt_cls.get_invoice_factory), u"Must be static method"
        factories.append(rt_cls.get_invoice_factory())
    return factories


def query_resource_data():
    factories = get_invoices_factories_resources_types()
    res = None
    for i, factory in enumerate(factories):
        if not i:
            res = factory.query_list()
        else:
            res.union(factory.query_list())
    return res


def get_factory_by_invoice_id(invoice_id):
    bound_resource = (
        query_resource_data()
        .filter(Invoice.id == invoice_id)
        .first()
    )
    resource = Resource.get(bound_resource.resource_id)
    source_cls = get_resource_class(resource.resource_type.name)
    factory = source_cls.get_invoice_factory()
    return factory
