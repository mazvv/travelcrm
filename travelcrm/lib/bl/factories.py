# -*coding: utf-8-*-

from inspect import isfunction

from ...interfaces import (
    IOutgoingPaymentFactory,
    IIncomePaymentFactory,
    IInvoiceFactory,
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


def get_incomes_factories_resources_types():
    factories = []
    for rt in get_resources_types_by_interface(IIncomePaymentFactory):
        rt_cls = get_resource_class(rt.name)
        assert isfunction(rt_cls.get_income_factory), u"Must be static method"
        factories.append(rt_cls.get_income_factory())
    return factories


def get_outgoings_factories_resources_types():
    factories = []
    for rt in get_resources_types_by_interface(IOutgoingPaymentFactory):
        rt_cls = get_resource_class(rt.name)
        assert isfunction(rt_cls.get_outgoing_factory), u"Must be static method"
        factories.append(rt_cls.get_outgoing_factory())
    return factories
