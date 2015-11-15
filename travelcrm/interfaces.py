# -*-coding: utf-8 -*-
from zope.interface import (
    Interface,
    Attribute,
)


class IResourceType(Interface):
    """ Resource Type """

    allowed_permisions = Attribute("Allowed permission for resource")


class ISubaccountFactory(Interface):
    """ Resource that can produce Subaccounts """

    def get_subaccount_factory():
        """ Method that returns class instance for outgoing interfaces
        This method must be static
        """


class IPortlet(Interface):
    """ Portlet identificator """

    pass


class IServiceType(Interface):
    """ Service """
    pass
