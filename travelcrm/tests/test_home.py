#-*-coding: utf-8-*-

import unittest
from pyramid import testing

class HomeTest(unittest.TestCase):
    def setUp(self):
        self.config = testing.setUp()

    def tearDown(self):
        testing.tearDown()

    def test_view_fn_forbidden(self):
        from pyramid.httpexceptions import HTTPForbidden
        from my.package import view_fn
        self.config.testing_securitypolicy(userid='hank',
                                           permissive=False)
        request = testing.DummyRequest()
        request.context = testing.DummyResource()
        self.assertRaises(HTTPForbidden, view_fn, request)

    def test_view_fn_allowed(self):
        from my.package import view_fn
        self.config.testing_securitypolicy(userid='hank',
                                           permissive=True)
        request = testing.DummyRequest()
        request.context = testing.DummyResource()
        response = view_fn(request)
        self.assertEqual(response, {'greeting':'hello'})
