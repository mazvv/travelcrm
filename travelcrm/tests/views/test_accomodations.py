#-*-coding: utf-8-*-

from mock import patch, MagicMock
from webob.multidict import MultiDict
from pyramid.testing import (
    DummyRequest, DummyResource
)

from ...tests.views import BaseViewTestCase
from ...views.accomodations import (
    Accomodation,
    AccomodationSearchForm,
    AccomodationsView,
    AccomodationForm,
    AccomodationAssignForm,
)


class TestAccomodationsView(BaseViewTestCase):
    
    def test_index(self):
        AccomodationsView._get_title = lambda x: 'test'
        view = AccomodationsView(DummyResource(), DummyRequest())
        self.assertEqual({'title': 'test'}, view.index())

    @patch.object(AccomodationSearchForm, 'validate')
    @patch.object(AccomodationSearchForm, 'submit')
    @patch.object(
        AccomodationSearchForm, '_qb',
        return_value=MagicMock(
            get_count=lambda: 10, get_serialized=lambda: []
        )
    )
    def test_list(self, _qb, submit, validate):
        validate.return_value = True
        view = AccomodationsView(DummyResource(), DummyRequest())
        self.assertSetEqual({'total', 'rows'}, set(view.list().keys()))

    @patch.object(
        Accomodation, 'by_resource_id', return_value=Accomodation(id=1)
    )
    def test_view(self, by_resource_id):
        from pyramid.httpexceptions import HTTPFound
        AccomodationsView._get_title = lambda x, y=None: 'test'

        view = AccomodationsView(
            DummyResource(), DummyRequest(params=MultiDict({'rid': 1}))
        )
        self.assertIsInstance(view.view(), HTTPFound)

        AccomodationsView.edit = lambda x=None: {}
        view = AccomodationsView(DummyResource(), DummyRequest())
        self.assertSetEqual({'title', 'readonly'}, set(view.view().keys()))
