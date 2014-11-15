# -*coding: utf-8-*-

from inspect import isfunction

from ...interfaces import (
    IInvoiceFactory,
    ISubaccountFactory,
    ICalculationFactory,
)

from ...lib.utils.resources_utils import (
    get_resources_types_by_interface,
    get_resource_class
)


def get_invoices_factories_resources_types():
    factories = []
    for rt in get_resources_types_by_interface(IInvoiceFactory):
        rt_cls = get_resource_class(rt.name)
        assert isfunction(rt_cls.get_invoice_factory), u"Must be static method"
        factories.append(rt_cls.get_invoice_factory())
    return factories


def get_subaccounts_factories_resources_types():
    factories = []
    for rt in get_resources_types_by_interface(ISubaccountFactory):
        rt_cls = get_resource_class(rt.name)
        assert isfunction(rt_cls.get_subaccount_factory), u"Must be static method"
        factories.append(rt_cls.get_subaccount_factory())
    return factories


def get_calculations_factories_resources_types():
    factories = []
    for rt in get_resources_types_by_interface(ICalculationFactory):
        rt_cls = get_resource_class(rt.name)
        assert isfunction(rt_cls.get_calculation_factory), u"Must be static method"
        factories.append(rt_cls.get_calculation_factory())
    return factories
