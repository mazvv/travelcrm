# -*-coding: utf-8-*-

import logging

from pyramid.view import view_config, view_defaults

from . import BaseView
from ..models.employee import Employee
from ..lib.utils.common_utils import translate as _
from ..lib.events.assigns import AssignRun
from ..forms.assigns import (
    AssignForm, 
)


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.assigns.AssignsResource',
)
class AssignsView(BaseView):

    @view_config(
        name='assign',
        request_method='GET',
        renderer='travelcrm:templates/assigns/assign.mako',
        permission='assign'
    )
    def assign(self):
        return {
            'id': self.request.params.get('id'),
            'title': self._get_title(_(u'Assign Maintainer')),
        }

    @view_config(
        name='assign',
        request_method='POST',
        renderer='json',
        permission='assign'
    )
    def _assign(self):
        form = AssignForm(self.request)
        if form.validate():
            employee_id, maintainer_id = form.submit()
            event = AssignRun(
                self.request,
                Employee.get(employee_id),
                Employee.get(maintainer_id)
            )
            self.request.registry.notify(event)
            return {
                'success_message': _(u'Task will run soon'),
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }
