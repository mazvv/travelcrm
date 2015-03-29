# -*-coding: utf-8-*-

import unittest

from pyramid import testing

from ..views.user import UserView


class TestUsers(unittest.TestCase):
    def setUp(self):
        self.config = testing.setUp()

    def tearDown(self):
        testing.tearDown()

    def test_index(self):
        context = testing.DummyResource()
        request = testing.DummyRequest()
        users = UserView(context, request)
        self.assertDictEqual({}, users.index())
