# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.position import Position
from ..lib.qb.positions import PositionsQueryBuilder
from ..lib.utils.common_utils import translate as _

from ..forms.positions import PositionSchema


log = logging.getLogger(__name__)


class Positions(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.positions.Positions',
        request_method='GET',
        renderer='travelcrm:templates/positions/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.positions.Positions',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        qb = PositionsQueryBuilder(self.context)
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
        context='..resources.positions.Positions',
        request_method='GET',
        renderer='travelcrm:templates/positions/form.mak',
        permission='add'
    )
    def add(self):
        return {
            'title': _(u"Add Company Position")
        }

    @view_config(
        name='add',
        context='..resources.positions.Positions',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        schema = PositionSchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params)
            position = Position(
                name=controls.get('name'),
                structure_id=controls.get('structure_id'),
                resource=self.context.create_resource()
            )
            DBSession.add(position)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': position.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.positions.Positions',
        request_method='GET',
        renderer='travelcrm:templates/positions/form.mak',
        permission='edit'
    )
    def edit(self):
        position = Position.get(self.request.params.get('id'))
        return {
            'title': _(u"Edit Company Position"),
            'item': position,
        }

    @view_config(
        name='edit',
        context='..resources.positions.Positions',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        schema = PositionSchema().bind(request=self.request)
        position = Position.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params)
            position.name = controls.get('name')
            position.structure_id = controls.get('structure_id')
            return {
                'success_message': _(u'Saved'),
                'response': position.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='copy',
        context='..resources.positions.Positions',
        request_method='GET',
        renderer='travelcrm:templates/positions/form.mak',
        permission='add'
    )
    def copy(self):
        position = Position.get(self.request.params.get('id'))
        return {
            'item': position,
            'title': _(u"Copy Company Position")
        }

    @view_config(
        name='copy',
        context='..resources.positions.Positions',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _copy(self):
        return self._add()

    @view_config(
        name='delete',
        context='..resources.positions.Positions',
        request_method='GET',
        renderer='travelcrm:templates/companies_structures/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'id': self.request.params.get('id')
        }

    @view_config(
        name='delete',
        context='..resources.positions.Positions',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        for id in self.request.params.getall('id'):
            position = Position.get(id)
            if position:
                DBSession.delete(position)
        return {'success_message': _(u'Deleted')}
