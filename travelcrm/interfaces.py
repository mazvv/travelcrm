# -*-coding: utf-8 -*-
from zope.interface import (
    Interface,
)


class IApp(Interface):
    """ Application """


class IResourceType(Interface):
    """ Resource Type """

    def allowed_permisions():
        """ Get allowed permission for resource
        """
