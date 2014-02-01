# -*-coding: utf-8 -*-
from zope.interface import (
    Interface,
)


class IResource(Interface):
    """ Resource """

    def allowed_permisions():
        """ Get allowed permission for resource
        """


class IResourcesContainer(Interface):
    """ Container of resources """
