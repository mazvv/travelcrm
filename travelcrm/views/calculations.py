# -*-coding: utf-8-*-

import logging

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound

from . import BaseView
from ..models import DBSession
from ..models.calculation import Calculation
from ..lib.utils.common_utils import translate as _

from ..forms.calculations import (
    CalculationForm,
    CalculationAutoloadForm,
    CalculationSearchForm
)
from ..lib.utils.resources_utils import get_resource_class


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.calculations.CalculationsResource',
)
class CalculationsView(BaseView):

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/calculations/index.mako',
        permission='view'
    )
    def index(self):
        id = self.request.params.get('id')
        return {
            'id': id,
            'title': self._get_title(),
        }

    @view_config(
        name='list',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def _list(self):
        form = CalculationSearchForm(self.request, self.context)
        form.validate()
        qb = form.submit()
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized()
        }

    @view_config(
        name='view',
        request_method='GET',
        renderer='travelcrm:templates/calculations/form.mako',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            calculation = Calculation.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': calculation.id}
                )
            )
        result = self.edit()
        result.update({
            'title': self._get_title(_(u'View')),
            'readonly': True,
        })
        return result

    @view_config(
        name='autoload',
        request_method='GET',
        renderer='travelcrm:templates/calculations/autoload.mako',
        permission='autoload'
    )
    def autoload(self):
        return {
            'title': _(u'Calculation Autoload'),
        }

    @view_config(
        name='autoload',
        request_method='POST',
        renderer='json',
        permission='autoload'
    )
    def _autoload(self):
        form = CalculationAutoloadForm(self.request)
        if form.validate():
            calculations = form.submit()
            DBSession.add_all(calculations)
        DBSession.flush()
        return {
            'success_message': _(u'Saved'),
        }

    @view_config(
        name='edit',
        request_method='GET',
        renderer='travelcrm:templates/calculations/form.mako',
        permission='edit'
    )
    def edit(self):
        calculation = Calculation.get(self.request.params.get('id'))
        return {
            'item': calculation,
            'title': self._get_title(_(u'Edit')),
        }

    @view_config(
        name='edit',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        calculation = Calculation.get(self.request.params.get('id'))
        form = CalculationForm(self.request)
        if form.validate():
            form.submit(calculation)
            return {
                'success_message': _(u'Saved'),
                'response': calculation.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='details',
        request_method='GET',
        renderer='travelcrm:templates/calculations/details.mako',
        permission='view'
    )
    def details(self):
        calculation = Calculation.get(self.request.params.get('id'))
        contract_resource = None
        if calculation.contract:
            resource_cls = get_resource_class(
                calculation.contract.resource.resource_type.name
            )
            contract_resource = resource_cls(self.request)
        return {
            'item': calculation,
            'contract_resource': contract_resource
        }

    @view_config(
        name='delete',
        request_method='GET',
        renderer='travelcrm:templates/calculations/delete.mako',
        permission='delete'
    )
    def delete(self):
        return {
            'title': self._get_title(_(u'Delete')),
            'id': self.request.params.get('id')
        }

    @view_config(
        name='delete',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        errors = False
        ids = self.request.params.getall('id')
        if ids:
            try:
                items = DBSession.query(Calculation).filter(
                    Calculation.id.in_(ids)
                )
                for item in items:
                    DBSession.delete(item)
                DBSession.flush()
            except:
                errors=True
                DBSession.rollback()
        if errors:
            return {
                'error_message': _(
                    u'Some objects could not be delete'
                ),
            }
        return {'success_message': _(u'Deleted')}
