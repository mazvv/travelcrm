# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.user import User
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.users import UsersQueryBuilder
from ..lib.utils.common_utils import translate as _

from ..forms.users import (
    UserAddSchema,
    UserEditSchema,
    UserSearchSchema
)


log = logging.getLogger(__name__)


class Users(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.users.Users',
        request_method='GET',
        xhr='True',
        renderer='travelcrm:templates/users/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.users.Users',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        schema = UserSearchSchema().bind(request=self.request)
        controls = schema.deserialize(self.request.params.mixed())
        qb = UsersQueryBuilder(self.context)
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
        context='..resources.users.Users',
        request_method='GET',
        renderer='travelcrm:templates/users/form.mak',
        permission='view'
    )
    def view(self):
        result = self.edit()
        result.update({
            'title': _(u"View User"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        context='..resources.users.Users',
        request_method='GET',
        renderer='travelcrm:templates/users/form.mak',
        permission='add'
    )
    def add(self):
        return {'title': _(u'Add User')}

    @view_config(
        name='add',
        context='..resources.users.Users',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        schema = UserAddSchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params.mixed())
            user = User(
                username=controls.get('username'),
                password=controls.get('password'),
                employee_id=controls.get('employee_id'),
                resource=self.context.create_resource()
            )
            for id in controls.get('note_id'):
                note = Note.get(id)
                user.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                user.resource.tasks.append(task)
            DBSession.add(user)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': user.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.users.Users',
        request_method='GET',
        renderer='travelcrm:templates/users/form.mak',
        permission='edit'
    )
    def edit(self):
        user = User.get(self.request.params.get('id'))
        return {'item': user, 'title': _(u'Edit User')}

    @view_config(
        name='edit',
        context='..resources.users.Users',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        schema = UserEditSchema().bind(request=self.request)
        user = User.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params.mixed())
            user.username = controls.get('username')
            user.employee_is = controls.get('employee_id')
            if controls.get('password'):
                user.password = controls.get('password')
            user.resource.notes = []
            user.resource.tasks = []
            for id in controls.get('note_id'):
                note = Note.get(id)
                user.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                user.resource.tasks.append(task)
            return {
                'success_message': _(u'Saved'),
                'response': user.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='delete',
        context='..resources.users.Users',
        request_method='GET',
        renderer='travelcrm:templates/users/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Users'),
            'id': self.request.params.get('id')
        }

    @view_config(
        name='delete',
        context='..resources.users.Users',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        errors = 0
        for id in self.request.params.getall('id'):
            item = User.get(id)
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
