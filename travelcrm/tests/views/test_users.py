# -*-coding: utf-8-*-

import mock
from pyramid import testing
from pyramid.httpexceptions import HTTPForbidden

from .. import BaseTestCase
from ...views.users import UsersView


class TestUsers(BaseTestCase):
    def setUp(self):
        BaseTestCase.setUp(self)
        self.context = testing.DummyResource('users')

    def test_index(self):
        request = testing.DummyRequest()
        request.context = self.context
        users = UsersView(self.context, request)
        self.assertDictEqual({}, users.index())

        self.config.testing_securitypolicy(
            userid='test',
            permissive=False
        )
        users = UsersView(self.context, request)
        self.assertRaises(HTTPForbidden, users.index)

        self.config.testing_securitypolicy(
            userid='test',
            permissive=True
        )
        users = UsersView(self.context, request)
        self.assertEqual(users.index(), {})
