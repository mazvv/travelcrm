# -*-coding: utf-8-*-

import logging

import colander
from sqlalchemy.orm.session import make_transient
from pyramid.view import view_config

from ..models import DBSession
from ..models.position import Position
from ..models.resource_type import ResourceType
from ..models.permision import Permision
from ..lib.qb.permisions import PermisionsQueryBuilder
from ..forms.permisions import PermisionSchema, PermisionCopySchema
from ..lib.utils.common_utils import translate as _
from ..lib.utils.resources_utils import get_resource_class


log = logging.getLogger(__name__)


class PositionsPermisions(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.permisions.Permisions',
        request_method='GET',
        renderer='travelcrm:templates/permisions/index.mak',
        permission='view'
    )
    def index(self):
        position = Position.get(self.request.params.get('id'))
        return {'position': position}

    @view_config(
        name='list',
        context='..resources.permisions.Permisions',
        permission='view',
        xhr='True',
        request_method='POST',
        renderer='json'
    )
    def list(self):
        qb = PermisionsQueryBuilder(
            self.request.params.get('position_id')
        )
        qb.search_simple(
            self.request.params.get('q')
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
        context='..resources.permisions.Permisions',
        request_method='GET',
        renderer='travelcrm:templates/permisions/form.mak',
        permission='edit'
    )
    def edit(self):
        position = Position.get(
            self.request.params.get('position_id')
        )
        resource_type = ResourceType.get(
            self.request.params.get('id')
        )
        if resource_type:
            resource_type_class = get_resource_class(resource_type.name)
            resource_type_resource = resource_type_class(self.request)
        else:
            resource_type_resource = None

        permision = (
            DBSession.query(Permision)
            .filter(
                Permision.condition_position_id(
                    position.id
                ),
                Permision.condition_resource_type_id(
                    resource_type.id
                )
            )
            .first()
        )
        return {
            'position': position,
            'resource_type': resource_type,
            'allowed_permisions': resource_type_resource.allowed_permisions,
            'allowed_scopes': resource_type_resource.allowed_scopes,
            'item': permision
        }

    @view_config(
        name='edit',
        context='..resources.permisions.Permisions',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        schema = PermisionSchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params)
            permision = (
                DBSession.query(Permision)
                .filter(
                    Permision.condition_position_id(
                        controls.get('position_id')
                    ),
                    Permision.condition_resource_type_id(
                        controls.get('resource_type_id')
                    )
                )
                .first()
            )
            if not permision:
                permision = Permision(
                    position_id=controls.get(
                        'position_id'
                    ),
                    resource_type_id=controls.get('resource_type_id')
                )
            permisions = self.request.params.getall('permisions')
            permisions = filter(None, permisions)
            permision.permisions = permisions
            permision.scope_type = controls.get('scope_type')
            if permision.scope_type == 'structure':
                permision.structure_id = (
                    controls.get('structure_id')
                )
            else:
                permision.structure_id = None
            DBSession.add(permision)
            return {'success_message': _(u'Saved')}
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='copy',
        context='..resources.permisions.Permisions',
        request_method='GET',
        renderer='travelcrm:templates/permisions/copy.mak',
        permission='edit'
    )
    def copy(self):
        position = Position.get(self.request.params.get('position_id'))
        return {
            'position': position,
            'title': _(u"Copy Permissions From Position")
        }

    @view_config(
        name='copy',
        context='..resources.permisions.Permisions',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _copy(self):
        schema = PermisionCopySchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params)
            (
                DBSession.query(Permision)
                .filter(
                    Permision.condition_position_id(
                        controls.get('position_id')
                    )
                )
                .delete()
            )
            permisions_from = (
                DBSession.query(Permision)
                .filter(
                    Permision.condition_position_id(
                        controls.get('from_position_id')
                    )
                )
            )
            for permision in permisions_from:
                make_transient(permision)
                permision.id = None
                permision.position_id = controls.get('position_id')
                DBSession.add(permision)
            return {'success_message': _(u'Copied')}
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }
