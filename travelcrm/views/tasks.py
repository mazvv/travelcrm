# -*-coding: utf-8-*-

import logging

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound

from . import BaseView
from ..models import DBSession
from ..models.task import Task
from ..lib.bl.subscriptions import subscribe_resource
from ..lib.utils.common_utils import translate as _
from ..lib.utils.resources_utils import get_resource_class
from ..forms.tasks import (
    TaskForm, 
    TaskSearchForm,
    TaskAssignForm,
)
from ..lib.events.tasks import (
    TaskCreated,
)
from ..lib.events.resources import (
    ResourceChanged,
    ResourceDeleted
)


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.tasks.TasksResource',
)
class TasksView(BaseView):

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/tasks/index.mako',
        permission='view'
    )
    def index(self):
        return {
            'title': self._get_title(),
        }

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
        name='counter',
        request_method='GET',
        renderer='sse',
        permission='view'
    )
    def counter(self):
        form = TaskSearchForm(self.request, self.context)
        form.validate()
        qb = form.submit()
        qb.advanced_search(**{'status': 'new'})
        return {
            'count': qb.query.count(),
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
            'title': self._get_title(_(u'View')),
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
        return {
            'title': self._get_title(_(u'Add')),
        }

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

            event = TaskCreated(self.request, task)
            event.registry()

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
        return {
            'item': task,
            'title': self._get_title(_(u'Edit')),
        }

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
            event = ResourceChanged(self.request, task)
            event.registry()
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
        name='copy',
        request_method='GET',
        renderer='travelcrm:templates/tasks/form.mako',
        permission='add'
    )
    def copy(self):
        task = Task.get_copy(self.request.params.get('id'))
        return {
            'action': self.request.path_url,
            'item': task,
            'title': self._get_title(_(u'Copy')),
        }

    @view_config(
        name='copy',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _copy(self):
        return self._add()

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
            'title': self._get_title(_(u'Delete')),
            'rid': self.request.params.get('rid')
        }

    @view_config(
        name='delete',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        errors = False
        ids = self.request.params.getall('id')
        if ids:
            try:
                items = DBSession.query(Task).filter(Task.id.in_(ids))
                for item in items:
                    DBSession.delete(item)
                    event = ResourceDeleted(self.request, item)
                    event.registry()
                DBSession.flush()
            except:
                errors=True
                DBSession.rollback()
        if errors:
            return {
                'error_message': _(
                    u'Some objects could not be delete'
                ),
            }
        return {'success_message': _(u'Deleted')}

    @view_config(
        name='assign',
        request_method='GET',
        renderer='travelcrm:templates/tasks/assign.mako',
        permission='assign'
    )
    def assign(self):
        return {
            'id': self.request.params.get('id'),
            'title': self._get_title(_(u'Assign Maintainer')),
        }

    @view_config(
        name='assign',
        request_method='POST',
        renderer='json',
        permission='assign'
    )
    def _assign(self):
        form = TaskAssignForm(self.request)
        if form.validate():
            form.submit(self.request.params.getall('id'))
            return {
                'success_message': _(u'Assigned'),
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='subscribe',
        request_method='GET',
        renderer='travelcrm:templates/tasks/subscribe.mako',
        permission='view'
    )
    def subscribe(self):
        return {
            'id': self.request.params.get('id'),
            'title': self._get_title(_(u'Subscribe')),
        }

    @view_config(
        name='subscribe',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def _subscribe(self):
        ids = self.request.params.getall('id')
        for id in ids:
            task = Task.get(id)
            subscribe_resource(self.request, task.resource)
        return {
            'success_message': _(u'Subscribed'),
        }
