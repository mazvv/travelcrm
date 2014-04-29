# -*-coding: utf-8-*-

import unittest
from pyramid import testing


class ResourceTypeTest(unittest.TestCase):
    def setUp(self):
        self.config = testing.setUp()

    def tearDown(self):
        testing.tearDown()

    def add_resource_type_forbidden(self):
        from pyramid.httpexceptions import HTTPForbidden
        from ..views.resources_types import ResourcesTypes
        self.config.testing_securitypolicy(userid='hank',
                                           permissive=False)
        request = testing.DummyRequest()
        request.context = testing.DummyResource()
        self.assertRaises(HTTPForbidden, view_fn, request)

    def add_resource_type_allowed(self):
        from my.package import view_fn
        self.config.testing_securitypolicy(userid='hank',
                                           permissive=True)
        request = testing.DummyRequest()
        request.context = testing.DummyResource()
        response = view_fn(request)
        self.assertEqual(response, {'greeting':'hello'})
