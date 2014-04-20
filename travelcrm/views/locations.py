# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.location import Location
from ..lib.qb.locations import LocationsQueryBuilder
from ..lib.utils.common_utils import translate as _

from ..forms.locations import LocationSchema


log = logging.getLogger(__name__)


class Locations(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.locations.Locations',
        request_method='GET',
        renderer='travelcrm:templates/locations/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.locations.Locations',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        qb = LocationsQueryBuilder(self.context)
        qb.search_simple(
            self.request.params.get('q'),
        )
        qb.advanced_search(
            updated_from=self.request.params.get('updated_from'),
            updated_to=self.request.params.get('updated_to'),
            modifier_id=self.request.params.get('modifier_id'),
            status=self.request.params.get('status'),
        )
        id = self.request.params.get('id')
        if id:
            qb.filter_id(id.split(','))
        qb.sort_query(
            self.request.params.get('sort'),
            self.request.params.get('order', 'asc')
        )
        qb.page_query(
            int(self.request.params.get('rows')),
            int(self.request.params.get('page'))
        )
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized()
        }

    @view_config(
        name='add',
        context='..resources.locations.Locations',
        request_method='GET',
        renderer='travelcrm:templates/locations/form.mak',
        permission='add'
    )
    def add(self):
        return {'title': _(u'Add Location')}

    @view_config(
        name='add',
        context='..resources.locations.Locations',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        schema = LocationSchema().bind(request=self.request)

        try:
            controls = schema.deserialize(self.request.params)
            location = Location(
                region_id=controls.get('region_id'),
                name=controls.get('name'),
                resource=self.context.create_resource(controls.get('status'))
            )
            DBSession.add(location)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': location.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.locations.Locations',
        request_method='GET',
        renderer='travelcrm:templates/locations/form.mak',
        permission='edit'
    )
    def edit(self):
        location = Location.get(self.request.params.get('id'))
        return {'item': location, 'title': _(u'Edit Location')}

    @view_config(
        name='edit',
        context='..resources.locations.Locations',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        schema = LocationSchema().bind(request=self.request)
        location = Location.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params)
            location.region_id = controls.get('region_id')
            location.name = controls.get('name')
            location.resource.status = controls.get('status')
            return {
                'success_message': _(u'Saved'),
                'response': location.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='copy',
        context='..resources.locations.Locations',
        request_method='GET',
        renderer='travelcrm:templates/locations/form.mak',
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
        context='..resources.locations.Locations',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _copy(self):
        return self._add()

    @view_config(
        name='delete',
        context='..resources.locations.Locations',
        request_method='GET',
        renderer='travelcrm:templates/locations/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'rid': self.request.params.get('rid')
        }

    @view_config(
        name='delete',
        context='..resources.locations.Locations',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        for id in self.request.params.getall('id'):
            location = Location.get(id)
            if location:
                DBSession.delete(location)
        return {'success_message': _(u'Deleted')}
