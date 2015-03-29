# -*-coding: utf-8-*-

import logging

from pyramid.view import view_config, view_defaults
from pyramid.response import Response
from pyramid.httpexceptions import HTTPFound

from ..models import DBSession
from ..models.resource import Resource
from ..models.touroperator import Touroperator
from ..lib.utils.common_utils import translate as _
from ..lib.helpers.fields import touroperators_combobox_field
from ..forms.touroperator import (
    TouroperatorForm, 
    TouroperatorSearchForm
)


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.touroperator.TouroperatorResource',
)
class TouroperatorView(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/touroperator/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        form = TouroperatorSearchForm(self.request, self.context)
        form.validate()
        qb = form.submit()
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized()
        }

    @view_config(
        name='view',
        request_method='GET',
        renderer='travelcrm:templates/touroperator/form.mak',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            touroperator = Touroperator.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': touroperator.id}
                )
            )
        result = self.edit()
        result.update({
            'title': _(u"View Touroperator"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        request_method='GET',
        renderer='travelcrm:templates/touroperator/form.mak',
        permission='add'
    )
    def add(self):
        return {
            'title': _(u'Add Touroperator'),
        }

    @view_config(
        name='add',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        form = TouroperatorForm(self.request)
        if form.validate():
            touroperator = form.submit()
            DBSession.add(touroperator)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': touroperator.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': touroperator.errors
            }

    @view_config(
        name='edit',
        request_method='GET',
        renderer='travelcrm:templates/touroperator/form.mak',
        permission='edit'
    )
    def edit(self):
        touroperator = Touroperator.get(self.request.params.get('id'))
        return {
            'item': touroperator,
            'title': _(u'Edit Touroperator'),
        }

    @view_config(
        name='edit',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        touroperator = Touroperator.get(self.request.params.get('id'))
        form = TouroperatorForm(self.request)
        if form.validate():
            form.submit(touroperator)
            return {
                'success_message': _(u'Saved'),
                'response': touroperator.id,
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='details',
        request_method='GET',
        renderer='travelcrm:templates/touroperator/details.mak',
        permission='view'
    )
    def details(self):
        touroperator = Touroperator.get(self.request.params.get('id'))
        return {
            'item': touroperator,
        }

    @view_config(
        name='delete',
        request_method='GET',
        renderer='travelcrm:templates/touroperator/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Touroperators'),
            'id': self.request.params.get('id')
        }

    @view_config(
        name='delete',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        errors = 0
        for id in self.request.params.getall('id'):
            item = Touroperator.get(id)
            if item:
                DBSession.begin_nested()
                try:
                    DBSession.delete(item)
                    DBSession.commit()
                except:
                    errors += 1
                    DBSession.rollback()
        if errors > 0:
            return {
                'error_message': _(
                    u'Some objects could not be delete'
                ),
            }
        return {'success_message': _(u'Deleted')}

    @view_config(
        name='combobox',
        request_method='POST',
        permission='view'
    )
    def _combobox(self):
        value = None
        resource = Resource.get(self.request.params.get('resource_id'))
        if resource:
            value = resource.touroperator.id
        return Response(
            touroperators_combobox_field(
                self.request, value, name=self.request.params.get('name')
            )
        )
