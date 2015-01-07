# -*-coding: utf-8-*-

from . import BaseTestCase
from travelcrm.lib.utils.resources_utils import get_resource_class_module
from travelcrm.lib.utils.resources_utils import get_resource_class_name
from travelcrm.resources.users import Users
from travelcrm.models.resource_type import ResourceType


class TestResourcesTypes(BaseTestCase):

    def test_get_resource_class_module(self):
        cls = Users
        self.assertEqual(cls.__module__, get_resource_class_module(cls))

    def test_get_resource_class_name(self):
        cls = Users
        self.assertEqual(cls.__name__, get_resource_class_name(cls))

    def test_get_resource_class(self):
        rt = ResourceType()
