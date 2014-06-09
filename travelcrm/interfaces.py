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
