#-*-coding: utf-8-*-

from webob.multidict import MultiDict

from pyramid.testing import DummyRequest

from ...tests.forms import BaseFormTestCase
from ...forms.addresses import AddressForm 


class TestAddressForm(BaseFormTestCase):
    
    def test_form_invalid(self):
        request = DummyRequest(
            params=MultiDict({'address': 'a'})
        )
        form = AddressForm(request)
        self.assertFalse(form.validate())
        
        self.assertIn('location_id', form._errors)
        self.assertIn('zip_code', form._errors)
        self.assertIn('address', form._errors)

    def test_form_valid(self):
        request = DummyRequest()
        csrf_token = request.session.get_csrf_token()
        request.params = (
            MultiDict({
                'csrf_token': csrf_token,
                'location_id': 10,
                'zip_code': '02121',
                'address': 'test'
            })
        )
        form = AddressForm(request)
        form.validate()
        self.assertTrue(form.validate())
