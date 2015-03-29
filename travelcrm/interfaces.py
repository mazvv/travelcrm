# -*-coding: utf-8 -*-
from zope.interface import (
    Interface,
    Attribute,
)


class IResourceType(Interface):
    """ Resource Type """

    allowed_permisions = Attribute("Allowed permission for resource")


class IInvoiceFactory(Interface):
    """ Resource that can be source of Invoice"""

    def get_invoice_factory():
        """ Method that returns class instance for invoice interfaces
        This method must be static
        """


class ISubaccountFactory(Interface):
    """ Resource that can produce Subaccounts """

    def get_subaccount_factory():
        """ Method that returns class instance for outgoing interfaces
        This method must be static
        """


class ICalculationFactory(Interface):
    """ Resource that can be source of Calculations"""

    def get_calculation_factory():
        """ Method that returns class instance for calculations interfaces
        This method must be static
        """


class IScheduler(Interface):
    """ Application scheduler jobs """

    pass


class IPortlet(Interface):
    """ Portlet identificator """

    pass


class IServiceType(Interface):
    """ Service """
    pass
