# -*-coding: utf-8-*-

import mock
from pyramid import testing
from pyramid.httpexceptions import HTTPFound, HTTPNotFound

from .. import BaseTestCase
from ...resources import Root
from ...views.home import HomeView


class TestHome(BaseTestCase):

    def test_auth(self):
        request = testing.DummyRequest()
        context = testing.DummyResource()

        home = HomeView(context, request)
        forgot_url = request.resource_url(
            Root(request), 'forgot'
        )
        auth_url = request.resource_url(
            Root(request), 'auth'
        )
        add_url = request.resource_url(
            Root(request), 'add'
        )        
        self.assertDictEqual(
            {'forgot_url': forgot_url, 'auth_url': auth_url, 'add_url': add_url}, 
            home.auth()
        )

    def test_auth_post_failed(self):
        request = testing.DummyRequest()
        context = testing.DummyResource()
        home = HomeView(context, request)
        info = home._auth()
        self.assertListEqual(
            info.keys(), ['error_message'], msg=u'Bad response'
        )
        
        request = testing.DummyRequest(post={'username': 'blabla'})
        home = HomeView(context, request)
        info = home._auth()
        self.assertListEqual(
            info.keys(), ['error_message'], msg=u'Bad response'
        )

    def test_auth_post_success(self):
        request = testing.DummyRequest(
            params={'username': 'admin', 'password':'adminadmin'}
        )
        context = testing.DummyResource()
        home = HomeView(context, request)
        info = home._auth()
        self.assertItemsEqual(
            info.keys(), ['success_message', 'redirect']
        )
        self.assertEqual(info['redirect'], request.resource_url(context))

    def test_logout(self):
        request = testing.DummyRequest()
        context = testing.DummyResource()
        home = HomeView(context, request)
        self.assertDictEqual({}, home.logout())

    def test_logout_post(self):
        request = testing.DummyRequest(params={})
        context = testing.DummyResource()
        home = HomeView(context, request)
        self.assertTrue(isinstance(home._logout(), HTTPFound))
