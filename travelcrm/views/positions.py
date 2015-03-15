# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config
from pyramid.httpexceptions import HTTPFound

from ..models import DBSession
from ..models.position import Position
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.positions import PositionsQueryBuilder
from ..lib.utils.common_utils import translate as _

from ..forms.positions import (
    PositionSchema,
    PositionSearchSchema
)


log = logging.getLogger(__name__)


class Positions(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.positions.Positions',
        request_method='GET',
        renderer='travelcrm:templates/positions/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.positions.Positions',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        schema = PositionSearchSchema().bind(request=self.request)
        controls = schema.deserialize(self.request.params.mixed())
        qb = PositionsQueryBuilder(self.context)
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
        context='..resources.positions.Positions',
        request_method='GET',
        renderer='travelcrm:templates/positions/form.mak',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            position = Position.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': position.id}
                )
            )
        result = self.edit()
        result.update({
            'title': _(u"View Position"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        context='..resources.positions.Positions',
        request_method='GET',
        renderer='travelcrm:templates/positions/form.mak',
        permission='add'
    )
    def add(self):
        return {
            'title': _(u"Add Company Position")
        }

    @view_config(
        name='add',
        context='..resources.positions.Positions',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        schema = PositionSchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params.mixed())
            position = Position(
                name=controls.get('name'),
                structure_id=controls.get('structure_id'),
                resource=self.context.create_resource()
            )
            for id in controls.get('note_id'):
                note = Note.get(id)
                position.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                position.resource.tasks.append(task)
            DBSession.add(position)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': position.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.positions.Positions',
        request_method='GET',
        renderer='travelcrm:templates/positions/form.mak',
        permission='edit'
    )
    def edit(self):
        position = Position.get(self.request.params.get('id'))
        return {
            'title': _(u"Edit Company Position"),
            'item': position,
        }

    @view_config(
        name='edit',
        context='..resources.positions.Positions',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        schema = PositionSchema().bind(request=self.request)
        position = Position.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params.mixed())
            position.name = controls.get('name')
            position.structure_id = controls.get('structure_id')
            position.resource.notes = []
            position.resource.tasks = []
            for id in controls.get('note_id'):
                note = Note.get(id)
                position.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                position.resource.tasks.append(task)
            return {
                'success_message': _(u'Saved'),
                'response': position.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='copy',
        context='..resources.positions.Positions',
        request_method='GET',
        renderer='travelcrm:templates/positions/form.mak',
        permission='add'
    )
    def copy(self):
        position = Position.get(self.request.params.get('id'))
        return {
            'item': position,
            'title': _(u"Copy Company Position")
        }

    @view_config(
        name='copy',
        context='..resources.positions.Positions',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _copy(self):
        return self._add()

    @view_config(
        name='delete',
        context='..resources.positions.Positions',
        request_method='GET',
        renderer='travelcrm:templates/companies_structures/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Passports'),
            'id': self.request.params.get('id')
        }

    @view_config(
        name='delete',
        context='..resources.positions.Positions',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        errors = 0
        for id in self.request.params.getall('id'):
            item = Position.get(id)
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
