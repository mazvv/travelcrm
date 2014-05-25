# -*coding: utf-8-*-
from inspect import isfunction

from ...interfaces import IInvoiceFactory

from ...lib.utils.resources_utils import (
    get_resources_types_by_interface,
    get_resource_class
)


def get_invoices_factories_resources_types():
    factories = []
    for rt in get_resources_types_by_interface(IInvoiceFactory):
        rt_cls = get_resource_class(rt.name)
        assert isfunction(rt_cls.invoice_factory), u"Must be static method"
        factories.append(rt_cls.invoice_factory())
    return factories
