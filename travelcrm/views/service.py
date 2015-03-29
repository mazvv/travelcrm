# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound

from ..models import DBSession
from ..models.service import Service
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.service import ServiceQueryBuilder
from ..lib.utils.common_utils import translate as _

from ..forms.service import (
    ServiceSchema, 
    ServiceSearchSchema
)


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.service.ServiceResource',
)
class ServiceView(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/services/index.mak',
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
        schema = ServiceSearchSchema().bind(request=self.request)
        controls = schema.deserialize(self.request.params.mixed())
        qb = ServiceQueryBuilder(self.context)
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
        request_method='GET',
        renderer='travelcrm:templates/services/form.mak',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            service = Service.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': service.id}
                )
            )
        result = self.edit()
        result.update({
            'title': _(u"View Service"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        request_method='GET',
        renderer='travelcrm:templates/services/form.mak',
        permission='add'
    )
    def add(self):
        return {'title': _(u'Add Service')}

    @view_config(
        name='add',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        schema = ServiceSchema().bind(request=self.request)

        try:
            controls = schema.deserialize(self.request.params.mixed())
            service = Service(
                name=controls.get('name'),
                account_item_id=controls.get('account_item_id'),
                display_text=controls.get('display_text'),
                descr=controls.get('descr'),
                resource_type_id=controls.get('resource_type_id'),
                resource=self.context.create_resource()
            )
            for id in controls.get('note_id'):
                note = Note.get(id)
                service.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                service.resource.tasks.append(task)
            DBSession.add(service)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': service.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        request_method='GET',
        renderer='travelcrm:templates/services/form.mak',
        permission='edit'
    )
    def edit(self):
        service = Service.get(self.request.params.get('id'))
        return {'item': service, 'title': _(u'Edit Service')}

    @view_config(
        name='edit',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        schema = ServiceSchema().bind(request=self.request)
        service = Service.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params.mixed())
            service.name = controls.get('name')
            service.account_item_id = controls.get('account_item_id')
            service.display_text = controls.get('display_text')
            service.resource_type_id = controls.get('resource_type_id')
            service.descr = controls.get('descr')
            service.resource.notes = []
            service.resource.tasks = []
            for id in controls.get('note_id'):
                note = Note.get(id)
                service.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                service.resource.tasks.append(task)
            return {
                'success_message': _(u'Saved'),
                'response': service.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='delete',
        request_method='GET',
        renderer='travelcrm:templates/services/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Services'),
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
            item = Service.get(id)
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
