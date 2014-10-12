# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.location import Location
from ..models.note import Note
from ..models.task import Task
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
            **self.request.params.mixed()
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
        name='view',
        context='..resources.locations.Locations',
        request_method='GET',
        renderer='travelcrm:templates/locations/form.mak',
        permission='view'
    )
    def view(self):
        result = self.edit()
        result.update({
            'title': _(u"View Location"),
            'readonly': True,
        })
        return result

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
            controls = schema.deserialize(self.request.params.mixed())
            location = Location(
                region_id=controls.get('region_id'),
                name=controls.get('name'),
                resource=self.context.create_resource()
            )
            for id in controls.get('note_id'):
                note = Note.get(id)
                location.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                location.resource.tasks.append(task)
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
            location.resource.notes = []
            location.resource.tasks = []
            for id in controls.get('note_id'):
                note = Note.get(id)
                location.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                location.resource.tasks.append(task)
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
            'title': _(u'Delete Locations'),
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
