# -*-coding: utf-8-*-

import logging
from pyramid.view import view_config, view_defaults

from . import BaseView
from ..resources.leads import LeadsResource
from ..forms.activities import (
    ActivitiesSearchForm,
    ActivitiesSettingsForm
)
from ..lib.utils.resources_utils import get_resource_type_by_resource
from ..lib.utils.security_utils import get_auth_employee
from ..lib.utils.common_utils import translate as _


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.activities.ActivitiesResource',
)
class ActivitiesView(BaseView):

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/activities/index.mako',
        permission='view'
    )
    def index(self):
        employee = get_auth_employee(self.request)
        return {
            'employee_id': employee.id
        }

    @view_config(
        name='list',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        form = ActivitiesSearchForm(self.request, LeadsResource(self.request))
        form.validate()
        qb = form.submit()
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized()
        }

    @view_config(
        name='settings',
        request_method='GET',
        renderer='travelcrm:templates/activities/settings.mako',
        permission='settings',
    )
    def settings(self):
        rt = get_resource_type_by_resource(self.context)
        return {
            'title': self._get_title(_(u'Settings')),
            'rt': rt,
        }

    @view_config(
        name='settings',
        request_method='POST',
        renderer='json',
        permission='settings',
    )
    def _settings(self):
        form = ActivitiesSettingsForm(self.request)
        if form.validate():
            form.submit()
            return {'success_message': _(u'Saved')}
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }
