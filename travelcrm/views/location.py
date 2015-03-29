# -*-coding: utf-8-*-

import logging

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound

from ..models import DBSession
from ..models.location import Location
from ..lib.utils.common_utils import translate as _

from ..forms.location import (
    LocationForm, 
    LocationSearchForm
)


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.location.LocationResource',
)
class LocationView(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/location/index.mak',
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
        form = LocationSearchForm(self.request, self.context)
        form.validate()
        qb = form.submit()
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized()
        }

    @view_config(
        name='view',
        request_method='GET',
        renderer='travelcrm:templates/location/form.mak',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            location = Location.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': location.id}
                )
            )
        result = self.edit()
        result.update({
            'title': _(u"View Location"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        request_method='GET',
        renderer='travelcrm:templates/location/form.mak',
        permission='add'
    )
    def add(self):
        return {'title': _(u'Add Location')}

    @view_config(
        name='add',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        form = LocationForm(self.request)
        if form.validate():
            location = form.submit()
            DBSession.add(location)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': location.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='edit',
        request_method='GET',
        renderer='travelcrm:templates/location/form.mak',
        permission='edit'
    )
    def edit(self):
        location = Location.get(self.request.params.get('id'))
        return {'item': location, 'title': _(u'Edit Location')}

    @view_config(
        name='edit',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        location = Location.get(self.request.params.get('id'))
        form = LocationForm(self.request)
        if form.validate():
            form.submit(location)
            return {
                'success_message': _(u'Saved'),
                'response': location.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='copy',
        request_method='GET',
        renderer='travelcrm:templates/location/form.mak',
        permission='add'
    )
    def copy(self):
        location = Location.get(self.request.params.get('id'))
        return {
            'item': location,
            'title': _(u"Copy Location")
        }

    @view_config(
        name='copy',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _copy(self):
        return self._add()

    @view_config(
        name='delete',
        request_method='GET',
        renderer='travelcrm:templates/location/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Locations'),
            'rid': self.request.params.get('rid')
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
            item = Location.get(id)
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
