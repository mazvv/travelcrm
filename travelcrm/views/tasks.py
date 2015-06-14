# -*-coding: utf-8-*-

import logging

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound

from ..models import DBSession
from ..models.task import Task
from ..lib.utils.common_utils import translate as _
from ..lib.utils.resources_utils import get_resource_class
from ..lib.scheduler.tasks import schedule_task_notification
from ..forms.tasks import (
    TaskForm, 
    TaskSearchForm
)


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.tasks.TasksResource',
)
class TasksView(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/tasks/index.mako',
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
        form = TaskSearchForm(self.request, self.context)
        form.validate()
        qb = form.submit()
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized()
        }

    @view_config(
        name='view',
        request_method='GET',
        renderer='travelcrm:templates/tasks/form.mako',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            task = Task.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': task.id}
                )
            )
        result = self.edit()
        result.update({
            'title': _(u"View Task"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        request_method='GET',
        renderer='travelcrm:templates/tasks/form.mako',
        permission='add'
    )
    def add(self):
        return {'title': _(u'Add Task')}

    @view_config(
        name='add',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        form = TaskForm(self.request)
        if form.validate():
            task = form.submit()
            DBSession.add(task)
            DBSession.flush()
            schedule_task_notification(self.request, task.id)
            return {
                'success_message': _(u'Saved'),
                'response': task.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='edit',
        request_method='GET',
        renderer='travelcrm:templates/tasks/form.mako',
        permission='edit'
    )
    def edit(self):
        task = Task.get(self.request.params.get('id'))
        return {'item': task, 'title': _(u'Edit Task')}

    @view_config(
        name='edit',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        task = Task.get(self.request.params.get('id'))
        form = TaskForm(self.request)
        if form.validate():
            form.submit(task)
            schedule_task_notification(self.request, task.id)
            return {
                'success_message': _(u'Saved'),
                'response': task.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='details',
        request_method='GET',
        renderer='travelcrm:templates/tasks/details.mako',
        permission='view'
    )
    def details(self):
        task = Task.get(self.request.params.get('id'))
        task_resource = None
        if task.task_resource:
            resource_cls = get_resource_class(
                task.task_resource.resource_type.name
            )
            task_resource = resource_cls(self.request)
        return {
            'item': task,
            'task_resource': task_resource,
        }

    @view_config(
        name='delete',
        request_method='GET',
        renderer='travelcrm:templates/tasks/delete.mako',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Tasks'),
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
            item = Task.get(id)
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
