#-*-coding: utf-8-*-

from mock import patch
from webob.multidict import MultiDict

from pyramid.testing import DummyRequest

from ...tests.forms import BaseFormTestCase
from ...models.account_item import AccountItem
from ...forms.accounts_items import AccountItemForm 


class TestAccountsItemsForm(BaseFormTestCase):
    
    def test_form_invalid(self):
        request = DummyRequest(params=MultiDict())
        form = AccountItemForm(request)
        self.assertFalse(form.validate())

    
    @patch.object(AccountItem, 'by_name', return_value=AccountItem())
    def test_form_unique_name(self, _by_name):
        request = DummyRequest(
            params=MultiDict({'name': 'test', 'csrf_token': 'test'})
        )
        form = AccountItemForm(request)
        form.validate()
        self.assertTrue('name' in form._errors)

    def test_form_self_parent(self):
        request = DummyRequest(
            params=MultiDict({'id': '1', 'parent_id': '1'})
        )
        form = AccountItemForm(request)
        form.validate()
        self.assertTrue('parent_id' in form._errors)

    @patch.object(AccountItem, 'by_name', return_value=None)
    def test_form_valid(self, _by_name):
        request = DummyRequest()
        csrf_token = request.session.get_csrf_token()
        request.params = (
            MultiDict({
                'name': 'test', 'csrf_token': csrf_token,
                'type': 'revenue', 'status': 'active', 'parent_id': 1
            })
        )
        form = AccountItemForm(request)
        form.validate()
        self.assertTrue(form.validate())
