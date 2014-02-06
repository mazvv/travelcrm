# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.company_position import CompanyPosition
from ..models.resource_type import ResourceType
from ..models.position_permision import PositionPermision
from ..lib.qb.positions_permisions import PositionsPermisionsQueryBuilder
from ..forms.positions_permisions import PositionPermisionSchema

from ..lib.utils.resources_utils import get_resource_class


log = logging.getLogger(__name__)


class PositionsPermisions(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.positions_permisions.PositionsPermisions',
        request_method='GET',
        renderer='travelcrm:templates/positions_permisions/index.mak',
        permission='view'
    )
    def index(self):
        company_position = CompanyPosition.get(self.request.params.get('id'))
        return {'company_position': company_position}

    @view_config(
        name='list',
        context='..resources.positions_permisions.PositionsPermisions',
        permission='view',
        xhr='True',
        request_method='POST',
        renderer='json'
    )
    def list(self):
        qb = PositionsPermisionsQueryBuilder(
            self.request.params.get('company_position_id')
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
        name='edit',
        context='..resources.positions_permisions.PositionsPermisions',
        request_method='GET',
        renderer='travelcrm:templates/positions_permisions/form.mak',
        permission='edit'
    )
    def edit(self):
        _ = self.request.translate
        company_position = CompanyPosition.get(
            self.request.params.get('companies_positions_id')
        )
        resource_type = ResourceType.get(
            self.request.params.get('id')
        )
        if resource_type:
            resource_type_class = get_resource_class(resource_type.name)
            resource_type_resource = resource_type_class(self.request)
        else:
            resource_type_resource = None

        position_permision = (
            DBSession.query(PositionPermision)
            .filter(
                PositionPermision.condition_company_position_id(
                    company_position.id
                ),
                PositionPermision.condition_resource_type_id(
                    resource_type.id
                )
            )
            .first()
        )

        return {
            'company_position': company_position,
            'resource_type': resource_type,
            'allowed_permisions': resource_type_resource.allowed_permisions,
            'item': position_permision
        }

    @view_config(
        name='edit',
        context='..resources.positions_permisions.PositionsPermisions',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        _ = self.request.translate
        schema = PositionPermisionSchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params)
            position_permision = (
                DBSession.query(PositionPermision)
                .filter(
                    PositionPermision.condition_company_position_id(
                        controls.get('companies_positions_id')
                    ),
                    PositionPermision.condition_resource_type_id(
                        controls.get('resources_types_id')
                    )
                )
                .first()
            )
            if not position_permision:
                position_permision = PositionPermision(
                    companies_positions_id=controls.get(
                        'companies_positions_id'
                    ),
                    resources_types_id=controls.get('resources_types_id')
                )
            permisions = self.request.params.getall('permisions')
            permisions = filter(None, permisions)
            position_permision.permisions = permisions
            position_permision.scope_type = controls.get('scope_type')
            if position_permision.scope_type == 'company':
                position_permision.companies_structures_id = (
                    controls.get('companies_struct_id')
                )
            else:
                position_permision.companies_structures_id = None
            DBSession.add(position_permision)
            return {'success_message': _(u'Saved')}
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }
