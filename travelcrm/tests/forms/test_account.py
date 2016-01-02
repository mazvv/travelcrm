#-*-coding: utf-8-*-

from mock import patch
from webob.multidict import MultiDict

from pyramid.testing import DummyRequest

from ...tests.forms import BaseFormTestCase
from ...models.account import Account
from ...forms.accounts import AccountForm 


class TestAccountForm(BaseFormTestCase):
    
    def test_form_invalid(self):
        request = DummyRequest(params=MultiDict())
        form = AccountForm(request)
        self.assertFalse(form.validate())
        
        self.assertIn('currency_id', form._errors)
        self.assertIn('name', form._errors)
        self.assertIn('account_type', form._errors)
        self.assertIn('display_text', form._errors)
        self.assertIn('status', form._errors)

    @patch.object(Account, 'by_name', return_value=Account())
    def test_form_unique_name(self, _by_name):
        request = DummyRequest(
            params=MultiDict({'name': 'test', 'csrf_token': 'test'})
        )
        form = AccountForm(request)
        form.validate()
        self.assertIn('name', form._errors)

    @patch.object(Account, 'by_name', return_value=None)
    def test_form_valid(self, _by_name):
        request = DummyRequest()
        csrf_token = request.session.get_csrf_token()
        request.params = (
            MultiDict({
                'name': 'test', 'csrf_token': csrf_token,
                'currency_id': 10,
                'account_type': 'bank', 'status': 'active',
                'display_text': 'test'
            })
        )
        form = AccountForm(request)
        form.validate()
        self.assertTrue(form.validate())
