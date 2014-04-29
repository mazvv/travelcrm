# -*-coding: utf-8-*-

import logging
import colander
from sqlalchemy.orm.session import make_transient
from pyramid.view import view_config

from ..models import DBSession
from ..models.position import Position
from ..models.navigation import Navigation
from ..lib.qb.navigations import (
    NavigationsQueryBuilder,
)
from ..lib.bl.navigations import get_next_position
from ..lib.utils.common_utils import translate as _
from ..forms.navigations import NavigationSchema, NavigationCopySchema


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
                icon_cls=controls.get('icon_cls'),
                sort_order=get_next_position(
                    controls.get('position_id'),
                    controls.get('parent_id')
                ),
                resource=self.context.create_resource()
            )
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
            navigation.icon_cls = controls.get('icon_cls')
            navigation.parent_id = controls.get('parent_id')
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
        for id in self.request.params.getall('id'):
            navigation = Navigation.get(id)
            if navigation:
                DBSession.delete(navigation)
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
            (
                DBSession.query(Navigation)
                .filter(
                    Navigation.condition_position_id(
                        controls.get('position_id')
                    )
                )
                .delete()
            )
            navigations_from = (
                DBSession.query(Navigation)
                .filter(
                    Navigation.condition_position_id(
                        controls.get('from_position_id')
                    )
                )
            )
            for navigation in navigations_from:
                make_transient(navigation)
                navigation.id = None
                navigation.position_id = controls.get('position_id')
                DBSession.add(navigation)
            return {'success_message': _(u'Copied')}
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }
