# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.company_position import CompanyPosition
from ..models.position_navigation import PositionNavigation
from ..lib.qb.positions_navigations import (
    PositionsNavigationsQueryBuilder,
)
from ..lib.bl.positions_navigations import get_next_position
from ..forms.positions_navigations import PositionNavigationSchema


log = logging.getLogger(__name__)


class PositionsNavigation(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.positions_navigations.PositionsNavigations',
        request_method='GET',
        renderer='travelcrm:templates/positions_navigations/index.mak',
        permission='view'
    )
    def index(self):
        company_position = CompanyPosition.get(self.request.params.get('id'))
        return {'company_position': company_position}

    @view_config(
        name='list',
        context='..resources.positions_navigations.PositionsNavigations',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        parent_id = self.request.params.get('id')
        companies_positions_id = (
            self.request.params.get('companies_positions_id')
        )

        qb = PositionsNavigationsQueryBuilder(self.context)
        qb.filter_company_position_id(companies_positions_id)
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
        context='..resources.positions_navigations.PositionsNavigations',
        request_method='GET',
        renderer='travelcrm:templates/positions_navigations/form.mak',
        permission='add'
    )
    def add(self):
        _ = self.request.translate
        company_position = CompanyPosition.get(
            self.request.params.get('companies_positions_id')
        )
        return {
            'company_position': company_position,
            'title': _(u"Add Navigation Item")
        }

    @view_config(
        name='add',
        context='..resources.positions_navigations.PositionsNavigations',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        _ = self.request.translate
        schema = PositionNavigationSchema().bind(request=self.request)

        try:
            controls = schema.deserialize(self.request.params)
            position_navigation = PositionNavigation(
                name=controls.get('name'),
                companies_positions_id=controls.get('companies_positions_id'),
                parent_id=controls.get('parent_id'),
                url=controls.get('url'),
                icon_cls=controls.get('icon_cls'),
                position=get_next_position(
                    controls.get('companies_positions_id'),
                    controls.get('parent_id')
                ),
                resource=self.context.create_resource(controls.get('status'))
            )
            DBSession.add(position_navigation)
            return {'success_message': _(u'Saved')}
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.positions_navigations.PositionsNavigations',
        request_method='GET',
        renderer='travelcrm:templates/positions_navigations/form.mak',
        permission='edit'
    )
    def edit(self):
        _ = self.request.translate
        position_navigation = PositionNavigation.get(
            self.request.params.get('id')
        )
        company_position = position_navigation.company_position
        return {
            'title': _(u"Edit Navigation Item"),
            'company_position': company_position,
            'item': position_navigation
        }

    @view_config(
        name='edit',
        context='..resources.positions_navigations.PositionsNavigations',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        _ = self.request.translate
        schema = PositionNavigationSchema().bind(request=self.request)
        position_navigation = PositionNavigation.get(
            self.request.params.get('id')
        )
        try:
            controls = schema.deserialize(self.request.params)
            position_navigation.name = controls.get('name')
            position_navigation.companies_positions_id = (
                controls.get('companies_positions_id')
            )
            position_navigation.url = controls.get('url')
            position_navigation.icon_cls = controls.get('icon_cls')
            position_navigation.parent_id = controls.get('parent_id')
            position_navigation.resource.status = controls.get('status')
            return {'success_message': _(u'Saved')}
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='delete',
        context='..resources.positions_navigations.PositionsNavigations',
        request_method='GET',
        renderer='travelcrm:templates/positions_navigations/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'id': self.request.params.get('id')
        }

    @view_config(
        name='delete',
        context='..resources.positions_navigations.PositionsNavigations',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        _ = self.request.translate
        for id in self.request.params.getall('id'):
            position_navigation = PositionNavigation.get(id)
            if position_navigation:
                DBSession.delete(position_navigation)
        return {'success_message': _(u'Deleted')}

    @view_config(
        name='up',
        context='..resources.positions_navigations.PositionsNavigations',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _up(self):
        position_navigation = PositionNavigation.get(
            self.request.params.get('id')
        )
        if position_navigation:
            position_navigation.change_position('up')

    @view_config(
        name='down',
        context='..resources.positions_navigations.PositionsNavigations',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _down(self):
        position_navigation = PositionNavigation.get(
            self.request.params.get('id')
        )
        if position_navigation:
            position_navigation.change_position('down')
