# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.roomcat import Roomcat
from ..lib.qb.roomcats import RoomcatsQueryBuilder
from ..lib.utils.common_utils import translate as _

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
        qb.advanced_search(
            updated_from=self.request.params.get('updated_from'),
            updated_to=self.request.params.get('updated_to'),
            modifier_id=self.request.params.get('modifier_id'),
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
        name='add',
        context='..resources.roomcats.Roomcats',
        request_method='GET',
        renderer='travelcrm:templates/roomcats/form.mak',
        permission='add'
    )
    def add(self):
        return {'title': _(u'Add Room Category')}

    @view_config(
        name='add',
        context='..resources.roomcats.Roomcats',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        schema = RoomcatSchema().bind(request=self.request)

        try:
            controls = schema.deserialize(self.request.params)
            roomcat = Roomcat(
                name=controls.get('name'),
                resource=self.context.create_resource()
            )
            DBSession.add(roomcat)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': roomcat.id
            }
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
        schema = RoomcatSchema().bind(request=self.request)
        roomcat = Roomcat.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params)
            roomcat.name = controls.get('name')
            return {
                'success_message': _(u'Saved'),
                'response': roomcat.id
            }
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
        for id in self.request.params.getall('id'):
            roomcat = Roomcat.get(id)
            if roomcat:
                DBSession.delete(roomcat)
        return {'success_message': _(u'Deleted')}
