# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.roomcat import Roomcat
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.roomcats import RoomcatsQueryBuilder
from ..lib.utils.common_utils import translate as _

from ..forms.roomcats import (
    RoomcatSchema, 
    RoomcatSearchSchema
)


log = logging.getLogger(__name__)


class Roomcats(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.roomcats.Roomcats',
        request_method='GET',
        renderer='travelcrm:templates/roomcats/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.roomcats.Roomcats',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        schema = RoomcatSearchSchema().bind(request=self.request)
        controls = schema.deserialize(self.request.params.mixed())
        qb = RoomcatsQueryBuilder(self.context)
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
        context='..resources.roomcats.Roomcats',
        request_method='GET',
        renderer='travelcrm:templates/roomcats/form.mak',
        permission='view'
    )
    def view(self):
        result = self.edit()
        result.update({
            'title': _(u"View Room Category"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        context='..resources.roomcats.Roomcats',
        request_method='GET',
        renderer='travelcrm:templates/roomcats/form.mak',
        permission='add'
    )
    def add(self):
        return {'title': _(u'Add Room Category')}

    @view_config(
        name='add',
        context='..resources.roomcats.Roomcats',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        schema = RoomcatSchema().bind(request=self.request)

        try:
            controls = schema.deserialize(self.request.params.mixed())
            roomcat = Roomcat(
                name=controls.get('name'),
                resource=self.context.create_resource()
            )
            for id in controls.get('note_id'):
                note = Note.get(id)
                roomcat.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                roomcat.resource.tasks.append(task)
            DBSession.add(roomcat)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': roomcat.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.roomcats.Roomcats',
        request_method='GET',
        renderer='travelcrm:templates/roomcats/form.mak',
        permission='edit'
    )
    def edit(self):
        roomcat = Roomcat.get(self.request.params.get('id'))
        return {'item': roomcat, 'title': _(u'Edit Room Category')}

    @view_config(
        name='edit',
        context='..resources.roomcats.Roomcats',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        schema = RoomcatSchema().bind(request=self.request)
        roomcat = Roomcat.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params.mixed())
            roomcat.name = controls.get('name')
            roomcat.resource.notes = []
            roomcat.resource.tasks = []
            for id in controls.get('note_id'):
                note = Note.get(id)
                roomcat.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                roomcat.resource.tasks.append(task)
            return {
                'success_message': _(u'Saved'),
                'response': roomcat.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='delete',
        context='..resources.roomcats.Roomcats',
        request_method='GET',
        renderer='travelcrm:templates/roomcats/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Room Categories'),
            'rid': self.request.params.get('rid')
        }

    @view_config(
        name='delete',
        context='..resources.roomcats.Roomcats',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        errors = 0
        for id in self.request.params.getall('id'):
            item = Roomcat.get(id)
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
