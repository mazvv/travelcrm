# -*-coding: utf-8-*-

import unittest

from pyramid import testing

from ..views.users import UsersView


class TestUsers(unittest.TestCase):
    def setUp(self):
        self.config = testing.setUp()

    def tearDown(self):
        testing.tearDown()

    def test_index(self):
        context = testing.DummyResource()
        request = testing.DummyRequest()
        users = UsersView(context, request)
        self.assertDictEqual({}, users.index())
