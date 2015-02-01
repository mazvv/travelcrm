# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.accomodation import Accomodation
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.accomodations import AccomodationsQueryBuilder
from ..lib.utils.common_utils import translate as _
from ..forms.accomodations import (
    AccomodationSchema,
    AccomodationSearchSchema
)


log = logging.getLogger(__name__)


class Accomodations(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.accomodations.Accomodations',
        request_method='GET',
        renderer='travelcrm:templates/accomodations/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.accomodations.Accomodations',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        schema = AccomodationSearchSchema().bind(request=self.request)
        controls = schema.deserialize(self.request.params.mixed())
        qb = AccomodationsQueryBuilder(self.context)
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
        context='..resources.accomodations.Accomodations',
        request_method='GET',
        renderer='travelcrm:templates/resources_types/form.mak',
        permission='view'
    )
    def view(self):
        result = self.edit()
        result.update({
            'title': _(u"View Accomodation"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        context='..resources.accomodations.Accomodations',
        request_method='GET',
        renderer='travelcrm:templates/accomodations/form.mak',
        permission='add'
    )
    def add(self):
        return {'title': _(u'Add Hotel Category')}

    @view_config(
        name='add',
        context='..resources.accomodations.Accomodations',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        schema = AccomodationSchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params.mixed())
            accomodation = Accomodation(
                name=controls.get('name'),
                resource=self.context.create_resource()
            )
            for id in controls.get('note_id'):
                note = Note.get(id)
                accomodation.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                accomodation.resource.tasks.append(task)
            DBSession.add(accomodation)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': accomodation.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.accomodations.Accomodations',
        request_method='GET',
        renderer='travelcrm:templates/accomodations/form.mak',
        permission='edit'
    )
    def edit(self):
        accomodation = Accomodation.get(self.request.params.get('id'))
        return {'item': accomodation, 'title': _(u'Edit Hotel Category')}

    @view_config(
        name='edit',
        context='..resources.accomodations.Accomodations',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        schema = AccomodationSchema().bind(request=self.request)
        accomodation = Accomodation.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params.mixed())
            accomodation.name = controls.get('name')
            accomodation.resource.notes = []
            accomodation.resource.tasks = []
            for id in controls.get('note_id'):
                note = Note.get(id)
                accomodation.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                accomodation.resource.tasks.append(task)
            return {
                'success_message': _(u'Saved'),
                'response': accomodation.id,
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='delete',
        context='..resources.accomodations.Accomodations',
        request_method='GET',
        renderer='travelcrm:templates/accomodations/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Accomodations'),
            'rid': self.request.params.get('rid')
        }

    @view_config(
        name='delete',
        context='..resources.accomodations.Accomodations',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        errors = 0
        for id in self.request.params.getall('id'):
            item = Accomodation.get(id)
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
