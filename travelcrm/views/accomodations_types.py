# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config
from pyramid.httpexceptions import HTTPFound

from ..models import DBSession
from ..models.accomodation_type import AccomodationType
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.accomodations_types import AccomodationsTypesQueryBuilder
from ..lib.utils.common_utils import translate as _
from ..forms.accomodations_types import (
    AccomodationTypeSchema,
    AccomodationTypeSearchSchema
)


log = logging.getLogger(__name__)


class AccomodationsTypes(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.accomodations_types.AccomodationsTypes',
        request_method='GET',
        renderer='travelcrm:templates/accomodations_types/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.accomodations_types.AccomodationsTypes',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        schema = AccomodationTypeSearchSchema().bind(request=self.request)
        controls = schema.deserialize(self.request.params.mixed())
        qb = AccomodationsTypesQueryBuilder(self.context)
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
        context='..resources.accomodations_types.AccomodationsTypes',
        request_method='GET',
        renderer='travelcrm:templates/resources_types/form.mak',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            accomodation_type = AccomodationType.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': accomodation_type.id}
                )
            )
        result = self.edit()
        result.update({
            'title': _(u"View Accomodation Type"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        context='..resources.accomodations_types.AccomodationsTypes',
        request_method='GET',
        renderer='travelcrm:templates/accomodations_types/form.mak',
        permission='add'
    )
    def add(self):
        return {'title': _(u'Add Hotel Category')}

    @view_config(
        name='add',
        context='..resources.accomodations_types.AccomodationsTypes',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        schema = AccomodationTypeSchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params.mixed())
            accomodation_type = AccomodationType(
                name=controls.get('name'),
                resource=self.context.create_resource()
            )
            for id in controls.get('note_id'):
                note = Note.get(id)
                accomodation_type.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                accomodation_type.resource.tasks.append(task)
            DBSession.add(accomodation_type)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': accomodation_type.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.accomodations_types.AccomodationsTypes',
        request_method='GET',
        renderer='travelcrm:templates/accomodations_types/form.mak',
        permission='edit'
    )
    def edit(self):
        accomodation_type = AccomodationType.get(self.request.params.get('id'))
        return {
            'item': accomodation_type,
            'title': _(u'Edit Accomodation Type')
        }

    @view_config(
        name='edit',
        context='..resources.accomodations_types.AccomodationsTypes',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        schema = AccomodationTypeSchema().bind(request=self.request)
        accomodation_type = AccomodationType.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params.mixed())
            accomodation_type.name = controls.get('name')
            accomodation_type.resource.notes = []
            accomodation_type.resource.tasks = []
            for id in controls.get('note_id'):
                note = Note.get(id)
                accomodation_type.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                accomodation_type.resource.tasks.append(task)
            return {
                'success_message': _(u'Saved'),
                'response': accomodation_type.id,
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='delete',
        context='..resources.accomodations_types.AccomodationsTypes',
        request_method='GET',
        renderer='travelcrm:templates/accomodations_types/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Accomodation Types'),
            'rid': self.request.params.get('rid')
        }

    @view_config(
        name='delete',
        context='..resources.accomodations_types.AccomodationsTypes',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        errors = 0
        for id in self.request.params.getall('id'):
            item = AccomodationType.get(id)
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
