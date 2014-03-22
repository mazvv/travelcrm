# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.roomcat import Roomcat
from ..lib.qb.roomcats import RoomcatsQueryBuilder

from ..forms.roomcats import RoomcatSchema


log = logging.getLogger(__name__)


class Roomcats(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.roomcats.Roomcats',
        request_method='GET',
        renderer='travelcrm:templates/roomcats/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.roomcats.Roomcats',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        qb = RoomcatsQueryBuilder(self.context)
        qb.search_simple(
            self.request.params.get('q'),
        )
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
        name='add',
        context='..resources.roomcats.Roomcats',
        request_method='GET',
        renderer='travelcrm:templates/roomcats/form.mak',
        permission='add'
    )
    def add(self):
        _ = self.request.translate
        return {'title': _(u'Add Room Category')}

    @view_config(
        name='add',
        context='..resources.roomcats.Roomcats',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        _ = self.request.translate
        schema = RoomcatSchema().bind(request=self.request)

        try:
            controls = schema.deserialize(self.request.params)
            roomcat = Roomcat(
                name=controls.get('name'),
                resource=self.context.create_resource(controls.get('status'))
            )
            DBSession.add(roomcat)
            return {'success_message': _(u'Saved')}
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.roomcats.Roomcats',
        request_method='GET',
        renderer='travelcrm:templates/roomcats/form.mak',
        permission='edit'
    )
    def edit(self):
        _ = self.request.translate
        roomcat = Roomcat.get(self.request.params.get('id'))
        return {'item': roomcat, 'title': _(u'Edit Room Category')}

    @view_config(
        name='edit',
        context='..resources.roomcats.Roomcats',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        _ = self.request.translate
        schema = RoomcatSchema().bind(request=self.request)
        roomcat = Roomcat.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params)
            roomcat.name = controls.get('name')
            roomcat.resource.status = controls.get('status')
            return {'success_message': _(u'Saved')}
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='delete',
        context='..resources.roomcats.Roomcats',
        request_method='GET',
        renderer='travelcrm:templates/roomcats/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'rid': self.request.params.get('rid')
        }

    @view_config(
        name='delete',
        context='..resources.roomcats.Roomcats',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        _ = self.request.translate
        for id in self.request.params.getall('id'):
            roomcat = Roomcat.get(id)
            if roomcat:
                DBSession.delete(roomcat)
        return {'success_message': _(u'Deleted')}
