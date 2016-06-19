#-*-coding: utf-8-*-

from mock import patch

from pyramid.testing import (
    DummyRequest, DummyResource
)

from ...tests.views import BaseViewTestCase
from ...forms.auth import ForgotForm, LoginSchema
from ...forms.companies import CompanyAddForm 


class TestHomeAuthView(BaseViewTestCase):
    
    def test_forbidden(self):
        from ...views.home import HomeView
        view = HomeView(DummyResource(), DummyRequest())
        self.assertSetEqual(
            {'forgot_url', 'auth_url', 'add_url'},
            set(view.auth().keys())
        )
 
    def test_allowed(self):
        from pyramid.httpexceptions import HTTPFound
        from ...views.home import HomeView
        
        self.config.testing_securitypolicy(
            userid='user',
            permissive=True
        )
        view = HomeView(DummyResource(), DummyRequest())
        self.assertIsInstance(view.auth(), HTTPFound)

    @patch.object(ForgotForm, 'validate')
    @patch.object(ForgotForm, 'submit')
    def test_forgot(self, submit, validate):
        from ...views.home import HomeView
        view = HomeView(DummyResource(), DummyRequest())
        response = view.forgot()
        self.assertIn('auth_url', response)

        submit.return_value = True
        validate.return_value = True
        response = view._forgot()
        self.assertIn('success_message', response)
        
        validate.return_value = False
        response = view._forgot()
        self.assertIn('error_message', response)

    def test_logout(self):
        from ...views.home import HomeView
        from pyramid.httpexceptions import HTTPFound
        view = HomeView(DummyResource(), DummyRequest())
        response = view.logout()
        self.assertEqual({}, response)

        response = view._logout()
        self.assertIsInstance(response, HTTPFound)

    @patch('travelcrm.views.home.can_create_company')
    @patch.object(CompanyAddForm, 'validate')
    @patch.object(CompanyAddForm, 'submit', return_value=True)
    def test_add(self, submit, validate, can_create_company):
        from ...views.home import HomeView
        from pyramid.httpexceptions import HTTPNotFound
        can_create_company.return_value = False

        view = HomeView(DummyResource(), DummyRequest())
        response = view.add()
        self.assertIsInstance(response, HTTPNotFound)
 
        can_create_company.return_value = True
        response = view.add()
        self.assertIn('auth_url', response)
        
        validate.return_value = True
        response = view._add()
        self.assertIn('success_message', response)
        
        validate.return_value = False
        response = view._add()
        self.assertIn('error_message', response)
        
    @patch('travelcrm.views.home.get_resources_types_by_interface')
    def test_index(self, _p):
        from ...views.home import HomeView
        _p.return_value = []
        view = HomeView(DummyResource(), DummyRequest())
        response = view.index()
        self.assertEqual(response, {'portlets': []})
