#-*-coding: utf-8-*-

from mock import patch
from webob.multidict import MultiDict

from pyramid.testing import DummyRequest

from ...tests.forms import BaseFormTestCase
from ...models.accomodation import Accomodation
from ...forms.accomodations import AccomodationForm 


class TestAccomodationsForm(BaseFormTestCase):
    
    def test_form_invalid(self):
        request = DummyRequest(params=MultiDict())
        form = AccomodationForm(request)
        self.assertFalse(form.validate())

    
    @patch.object(Accomodation, 'by_name', return_value=Accomodation())
    def test_form_unique_name(self, _by_name):
        request = DummyRequest(
            params=MultiDict({'name': 'test', 'csrf_token': 'test'})
        )
        form = AccomodationForm(request)
        form.validate()
        self.assertTrue('name' in form._errors)

    @patch.object(Accomodation, 'by_name', return_value=None)
    def test_form_valid(self, _by_name):
        request = DummyRequest()
        csrf_token = request.session.get_csrf_token()
        request.params = (
            MultiDict({
                'name': 'test', 'csrf_token': csrf_token
            })
        )
        form = AccomodationForm(request)
        form.validate()
        self.assertTrue(form.validate())
