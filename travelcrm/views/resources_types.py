# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config
from pyramid.httpexceptions import HTTPFound

from ..models import DBSession
from ..models.resource_type import ResourceType
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.resources_types import ResourcesTypesQueryBuilder
from ..lib.utils.common_utils import translate as _
from ..lib.utils.resources_utils import get_resource_class

from ..forms.resources_types import ResourceTypeSchema


log = logging.getLogger(__name__)


class ResourcesTypes(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.resources_types.ResourcesTypes',
        request_method='GET',
        renderer='travelcrm:templates/resources_types/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.resources_types.ResourcesTypes',
        permission='view',
        xhr='True',
        request_method='POST',
        renderer='json'
    )
    def list(self):
        qb = ResourcesTypesQueryBuilder(self.context)
        qb.search_simple(
            self.request.params.get('q')
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
        context='..resources.resources_types.ResourcesTypes',
        request_method='GET',
        renderer='travelcrm:templates/resources_types/form.mak',
        permission='view'
    )
    def view(self):
        result = self.edit()
        result.update({
            'title': _(u"View Resources Type"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        context='..resources.resources_types.ResourcesTypes',
        request_method='GET',
        renderer='travelcrm:templates/resources_types/form.mak',
        permission='add'
    )
    def add(self):
        return {
            'title': _(u"Add Resources Type")
        }

    @view_config(
        name="add",
        context="..resources.resources_types.ResourcesTypes",
        request_method="POST",
        renderer='json',
        permission="add"
    )
    def _add(self):
        schema = ResourceTypeSchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params.mixed())
            resources_type = ResourceType(
                humanize=controls.get('humanize'),
                name=controls.get('name'),
                resource=controls.get('resource'),
                customizable=controls.get('customizable'),
                description=controls.get('description'),
                resource_obj=self.context.create_resource()
            )
            for id in controls.get('note_id'):
                note = Note.get(id)
                resources_type.resource_obj.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                resources_type.resource_obj.tasks.append(task)
            DBSession.add(resources_type)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': resources_type.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.resources_types.ResourcesTypes',
        request_method='GET',
        renderer='travelcrm:templates/resources_types/form.mak',
        permission='edit'
    )
    def edit(self):
        resources_type = ResourceType.get(self.request.params.get('id'))
        return {
            'item': resources_type,
            'title': _(u"Edit Resources Type")
        }

    @view_config(
        name="edit",
        context="..resources.resources_types.ResourcesTypes",
        request_method="POST",
        renderer='json',
        permission="edit"
    )
    def _edit(self):
        schema = ResourceTypeSchema().bind(request=self.request)
        resources_type = ResourceType.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params.mixed())
            resources_type.humanize = controls.get('humanize')
            resources_type.name = controls.get('name')
            resources_type.resource = controls.get('resource')
            resources_type.customizable = controls.get('customizable')
            resources_type.description = controls.get('description')
            resources_type.resource_obj.notes = []
            resources_type.resource_obj.tasks = []
            for id in controls.get('note_id'):
                note = Note.get(id)
                resources_type.resource_obj.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                resources_type.resource_obj.tasks.append(task)
            return {
                'success_message': _(u'Saved'),
                'response': resources_type.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='copy',
        context='..resources.resources_types.ResourcesTypes',
        request_method='GET',
        renderer='travelcrm:templates/resources_types/form.mak',
        permission='add'
    )
    def copy(self):
        resources_type = ResourceType.get(self.request.params.get('id'))
        return {
            'item': resources_type,
            'title': _(u"Copy Resources Type")
        }

    @view_config(
        name='copy',
        context='..resources.resources_types.ResourcesTypes',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _copy(self):
        return self._add()

    @view_config(
        name='delete',
        context='..resources.resources_types.ResourcesTypes',
        request_method='GET',
        renderer='travelcrm:templates/resources_types/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Resources Types'),
            'id': self.request.params.get('id')
        }

    @view_config(
        name="delete",
        context="..resources.resources_types.ResourcesTypes",
        request_method="POST",
        renderer='json',
        permission="delete"
    )
    def _delete(self):
        errors = 0
        for id in self.request.params.getall('id'):
            item = ResourceType.get(id)
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
        name='settings',
        context='..resources.resources_types.ResourcesTypes',
        request_method='GET',
        renderer='travelcrm:templates/resources_types/settings.mak',
        permission='settings'
    )
    def settings(self):
        id = self.request.params.get('id')
        rt = ResourceType.get(id)
        if rt.customizable:
            rt_ctx = get_resource_class(rt.name)
            return HTTPFound(
                location=self.request.resource_url(
                    rt_ctx(self.request), 'settings'
                )
            )
        return {
            'title': _(u'Not Allowed')
        }
