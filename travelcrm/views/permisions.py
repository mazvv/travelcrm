# -*-coding: utf-8-*-

import logging

from pyramid.view import view_config, view_defaults

from . import BaseView
from ..models import DBSession
from ..models.position import Position
from ..models.resource_type import ResourceType
from ..models.permision import Permision
from ..forms.permisions import (
    PermisionForm,
    PermisionSearchForm,
    PermisionCopyForm
)
from ..lib.utils.common_utils import translate as _
from ..lib.utils.resources_utils import get_resource_class


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.permisions.PermisionsResource',
)
class PermisionsView(BaseView):

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/permisions/index.mako',
        permission='view'
    )
    def index(self):
        position = Position.get(self.request.params.get('id'))
        return {
            'position': position,
            'title': self._get_title(),
        }

    @view_config(
        name='list',
        permission='view',
        xhr='True',
        request_method='POST',
        renderer='json'
    )
    def list(self):
        form = PermisionSearchForm(self.request, self.context)
        form.validate()
        qb = form.submit()
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized()
        }

    @view_config(
        name='edit',
        request_method='GET',
        renderer='travelcrm:templates/permisions/form.mako',
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
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        form = PermisionForm(self.request)
        if form.validate():
            permision = form.submit()
            DBSession.add(permision)
            return {'success_message': _(u'Saved')}
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='copy',
        request_method='GET',
        renderer='travelcrm:templates/permisions/copy.mako',
        permission='edit'
    )
    def copy(self):
        position = Position.get(self.request.params.get('position_id'))
        return {
            'action': self.request.path_url,
            'position': position,
            'title': self._get_title(_(u'Copy')),
        }

    @view_config(
        name='copy',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _copy(self):
        form = PermisionCopyForm(self.request)
        if form.validate():
            form.submit()
            return {'success_message': _(u'Copied')}
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }
