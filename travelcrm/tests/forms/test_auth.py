#-*-coding: utf-8-*-

from mock import patch

from pyramid.testing import DummyRequest

from ...tests.forms import BaseFormTestCase
from ...forms.auth import LoginSchema
from ...models.user import User
from ...models.employee import Employee


class TestAuthForm(BaseFormTestCase):
    
    @patch.object(User, 'by_username')
    def test_form_none(self, by_username):
        by_username.return_value = None
        request = DummyRequest(params={})
        schema = LoginSchema()
        controls = schema.deserialize(request.params)
        user = User.by_username(controls.get('username'))
        self.assertTrue(user == None)
     
    @patch.object(
        User, 'by_username',
        return_value=User(
            validate_password=lambda x: True
        )
    )
    def test_form_user(self, user):
        user.employee = Employee()
        request = DummyRequest()
        schema = LoginSchema()
        controls = schema.deserialize(request.params)
        self.assertTrue(user != None)
