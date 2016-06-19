#-*-coding: utf-8-*-

from pyramid import testing

from ...tests import BaseTestCase


class BaseViewTestCase(BaseTestCase):
    
    def setUp(self):
        super(BaseViewTestCase, self).setUp()
        request = testing.DummyRequest()
        self.config = testing.setUp(request=request)        
 
    def tearDown(self):
        testing.tearDown()
