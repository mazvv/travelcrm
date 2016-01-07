#-*-coding: utf-8-*-

from mock import patch
from webob.multidict import MultiDict

from pyramid.testing import DummyRequest

from ...tests.forms import BaseFormTestCase
from ...models.advsource import Advsource
from ...forms.advsources import AdvsourceForm 


class TestAdvsourceForm(BaseFormTestCase):
    
    def test_form_invalid(self):
        request = DummyRequest(params=MultiDict())
        form = AdvsourceForm(request)
        self.assertFalse(form.validate())
        
        self.assertIn('name', form._errors)

    @patch.object(Advsource, 'by_name', return_value=Advsource())
    def test_form_unique_name(self, _by_name):
        request = DummyRequest(
            params=MultiDict({'name': 'test', 'csrf_token': 'test'})
        )
        form = AdvsourceForm(request)
        form.validate()
        self.assertIn('name', form._errors)

    @patch.object(Advsource, 'by_name', return_value=None)
    def test_form_valid(self, _by_name):
        request = DummyRequest()
        csrf_token = request.session.get_csrf_token()
        request.params = (
            MultiDict({
                'csrf_token': csrf_token,
                'name': 'test', 
            })
        )
        form = AdvsourceForm(request)
        form.validate()
        self.assertTrue(form.validate())
