# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config
from pyramid.httpexceptions import HTTPFound

from ..models import DBSession
from ..models.hotelcat import Hotelcat
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.hotelcats import HotelcatsQueryBuilder
from ..lib.utils.common_utils import translate as _

from ..forms.hotelcats import (
    HotelcatSchema, 
    HotelcatSearchSchema
)


log = logging.getLogger(__name__)


class Hotelcats(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.hotelcats.Hotelcats',
        request_method='GET',
        renderer='travelcrm:templates/hotelcats/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.hotelcats.Hotelcats',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        schema = HotelcatSearchSchema().bind(request=self.request)
        controls = schema.deserialize(self.request.params.mixed())
        qb = HotelcatsQueryBuilder(self.context)
        qb.search_simple(controls.get('q'))
        qb.advanced_search(**controls)
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
        context='..resources.hotelcats.Hotelcats',
        request_method='GET',
        renderer='travelcrm:templates/hotelcats/form.mak',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            hotelcat = Hotelcat.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': hotelcat.id}
                )
            )
        result = self.edit()
        result.update({
            'title': _(u"View Hotel Category"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        context='..resources.hotelcats.Hotelcats',
        request_method='GET',
        renderer='travelcrm:templates/hotelcats/form.mak',
        permission='add'
    )
    def add(self):
        return {'title': _(u'Add Hotel Category')}

    @view_config(
        name='add',
        context='..resources.hotelcats.Hotelcats',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        schema = HotelcatSchema().bind(request=self.request)

        try:
            controls = schema.deserialize(self.request.params.mixed())
            hotelcat = Hotelcat(
                name=controls.get('name'),
                resource=self.context.create_resource()
            )
            for id in controls.get('note_id'):
                note = Note.get(id)
                hotelcat.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                hotelcat.resource.tasks.append(task)
            DBSession.add(hotelcat)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': hotelcat.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.hotelcats.Hotelcats',
        request_method='GET',
        renderer='travelcrm:templates/hotelcats/form.mak',
        permission='edit'
    )
    def edit(self):
        hotelcat = Hotelcat.get(self.request.params.get('id'))
        return {'item': hotelcat, 'title': _(u'Edit Hotel Category')}

    @view_config(
        name='edit',
        context='..resources.hotelcats.Hotelcats',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        schema = HotelcatSchema().bind(request=self.request)
        hotelcat = Hotelcat.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params.mixed())
            hotelcat.name = controls.get('name')
            hotelcat.resource.notes = []
            hotelcat.resource.tasks = []
            for id in controls.get('note_id'):
                note = Note.get(id)
                hotelcat.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                hotelcat.resource.tasks.append(task)
            return {
                'success_message': _(u'Saved'),
                'response': hotelcat.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='delete',
        context='..resources.hotelcats.Hotelcats',
        request_method='GET',
        renderer='travelcrm:templates/hotelcats/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Hotel Categories'),
            'rid': self.request.params.get('rid')
        }

    @view_config(
        name='delete',
        context='..resources.hotelcats.Hotelcats',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        errors = 0
        for id in self.request.params.getall('id'):
            item = Hotelcat.get(id)
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
