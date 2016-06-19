#-*-coding: utf-8-*-

from mock import patch

from webob.multidict import MultiDict

from pyramid.testing import DummyRequest

from ...tests.forms import BaseFormTestCase
from ...forms.companies import CompanyAddForm


class TestCompaniesForm(BaseFormTestCase):
    
    def test_form_add_invalid(self):
        request = DummyRequest(params=MultiDict())
        form = CompanyAddForm(request)
        self.assertFalse(form.validate())

    @patch('travelcrm.forms.companies.schedule_company_creation')
    def test_form_add_valid(self, schedule_company_creation):
        request = DummyRequest()
        csrf_token = request.session.get_csrf_token()
        request.params = (
            MultiDict({
                'name': 'test',
                'csrf_token': csrf_token,
                'email': 'test@mail.com',
                'timezone': 'Europe',
                'locale': 'en',
                'currency_id': 10
            })
        )
        form = CompanyAddForm(request)
        form.validate()
        self.assertTrue(form.validate())
        form.submit()
        schedule_company_creation.assert_called_once()
