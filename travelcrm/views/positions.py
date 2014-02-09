# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.position import Position
from ..lib.qb.positions import PositionsQueryBuilder
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
        qb.sort_query(
            self.request.params.get('sort'),
            self.request.params.get('order', 'asc')
        )
        if self.request.params.get('struct_id'):
            qb.filter_structure_id(self.request.params.get('struct_id'))
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
        _ = self.request.translate
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
        _ = self.request.translate
        schema = PositionSchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params)
            position = Position(
                name=controls.get('name'),
                structure_id=controls.get('structure_id'),
                resource=self.context.create_resource(controls.get('status'))
            )
            DBSession.add(position)
            return {'success_message': _(u'Saved')}
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
        _ = self.request.translate
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
        _ = self.request.translate
        schema = PositionSchema().bind(request=self.request)
        structure = Structure.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params)
            structure.name = controls.get('name')
            structure.companies_id = controls.get('companies_id')
            structure.parent_id = controls.get('parent_id'),
            company_struct.resource.status = controls.get('status')
            return {'success_message': _(u'Saved')}
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='copy',
        context='..resources.positions.Positions',
        request_method='GET',
        renderer='travelcrm:templates/companies_structures/form.mak',
        permission='add'
    )
    def copy(self):
        _ = self.request.translate
        struct = Structure.get(self.request.params.get('id'))
        company = struct.company
        return {
            'title': _(u"Copy Company Structure"),
            'item': struct,
            'company': company
        }

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
        _ = self.request.translate
        for id in self.request.params.getall('id'):
            company_position = Position.get(id)
            if company_position:
                DBSession.delete(company_position)
        return {'success_message': _(u'Deleted')}
