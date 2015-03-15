# -*-coding: utf-8-*-

import logging
import colander
from pyramid.view import view_config
from pyramid.httpexceptions import HTTPFound

from ..models import DBSession
from ..models.position import Position
from ..models.navigation import Navigation
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.navigations import NavigationsQueryBuilder
from ..lib.bl.navigations import (
    get_next_position,
    copy_from_position,
)
from ..lib.utils.common_utils import translate as _
from ..forms.navigations import (
    NavigationSchema,
    NavigationCopySchema,
)


log = logging.getLogger(__name__)


class Navigations(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.navigations.Navigations',
        request_method='GET',
        renderer='travelcrm:templates/navigations/index.mak',
        permission='view'
    )
    def index(self):
        position = Position.get(self.request.params.get('id'))
        return {'position': position}

    @view_config(
        name='list',
        context='..resources.navigations.Navigations',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        parent_id = self.request.params.get('id')
        position_id = (
            self.request.params.get('position_id')
        )

        qb = NavigationsQueryBuilder(self.context)
        qb.filter_position_id(position_id)
        qb.filter_parent_id(
            parent_id,
            with_chain=self.request.params.get('with_chain')
        )
        qb.sort_query(
            self.request.params.get('sort'),
            self.request.params.get('order', 'asc')
        )
        if self.request.params.get('rows'):
            qb.page_query(
                int(self.request.params.get('rows')),
                int(self.request.params.get('page', 1))
            )
        return qb.get_serialized()

    @view_config(
        name='view',
        context='..resources.navigations.Navigations',
        request_method='GET',
        renderer='travelcrm:templates/navigations/form.mak',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            navigation = Navigation.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': navigation.id}
                )
            )
        result = self.edit()
        result.update({
            'title': _(u"View Navigation"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        context='..resources.navigations.Navigations',
        request_method='GET',
        renderer='travelcrm:templates/navigations/form.mak',
        permission='add'
    )
    def add(self):
        position = Position.get(
            self.request.params.get('position_id')
        )
        return {
            'position': position,
            'title': _(u"Add Navigation Item")
        }

    @view_config(
        name='add',
        context='..resources.navigations.Navigations',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        schema = NavigationSchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params)
            navigation = Navigation(
                name=controls.get('name'),
                position_id=controls.get('position_id'),
                parent_id=controls.get('parent_id'),
                url=controls.get('url'),
                action=controls.get('action'),
                icon_cls=controls.get('icon_cls'),
                separator_before=controls.get('separator_before'),
                sort_order=get_next_position(
                    controls.get('position_id'),
                    controls.get('parent_id')
                ),
                resource=self.context.create_resource()
            )
            for id in controls.get('note_id'):
                note = Note.get(id)
                navigation.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                navigation.resource.tasks.append(task)
            DBSession.add(navigation)
            return {'success_message': _(u'Saved')}
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.navigations.Navigations',
        request_method='GET',
        renderer='travelcrm:templates/navigations/form.mak',
        permission='edit'
    )
    def edit(self):
        navigation = Navigation.get(
            self.request.params.get('id')
        )
        position = navigation.position
        return {
            'title': _(u"Edit Navigation Item"),
            'position': position,
            'item': navigation
        }

    @view_config(
        name='edit',
        context='..resources.navigations.Navigations',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        schema = NavigationSchema().bind(request=self.request)
        navigation = Navigation.get(
            self.request.params.get('id')
        )
        try:
            controls = schema.deserialize(self.request.params)
            navigation.name = controls.get('name')
            navigation.position_id = (
                controls.get('position_id')
            )
            navigation.url = controls.get('url')
            navigation.action = controls.get('action')
            navigation.icon_cls = controls.get('icon_cls')
            navigation.separator_before = controls.get('separator_before')
            navigation.parent_id = controls.get('parent_id')
            navigation.resource.notes = []
            navigation.resource.tasks = []
            for id in controls.get('note_id'):
                note = Note.get(id)
                navigation.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                navigation.resource.tasks.append(task)
            return {'success_message': _(u'Saved')}
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='delete',
        context='..resources.navigations.Navigations',
        request_method='GET',
        renderer='travelcrm:templates/navigations/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Navigations'),
            'id': self.request.params.get('id')
        }

    @view_config(
        name='delete',
        context='..resources.navigations.Navigations',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        errors = 0
        for id in self.request.params.getall('id'):
            item = Navigation.get(id)
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
        name='up',
        context='..resources.navigations.Navigations',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _up(self):
        navigation = Navigation.get(
            self.request.params.get('id')
        )
        if navigation:
            navigation.change_position('up')

    @view_config(
        name='down',
        context='..resources.navigations.Navigations',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _down(self):
        navigation = Navigation.get(
            self.request.params.get('id')
        )
        if navigation:
            navigation.change_position('down')

    @view_config(
        name='copy',
        context='..resources.navigations.Navigations',
        request_method='GET',
        renderer='travelcrm:templates/navigations/copy.mak',
        permission='edit'
    )
    def copy(self):
        position = Position.get(self.request.params.get('position_id'))
        return {
            'position': position,
            'title': _(u"Copy Menu From Position")
        }

    @view_config(
        name='copy',
        context='..resources.navigations.Navigations',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _copy(self):
        schema = NavigationCopySchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params)
            copy_from_position(
                controls.get('from_position_id'),
                controls.get('position_id'),
            )
            return {'success_message': _(u'Copied')}
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }
