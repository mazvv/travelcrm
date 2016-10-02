# -*-coding: utf-8-*-

import logging

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound

from . import BaseView
from ..models import DBSession
from ..models.outgoing import Outgoing
from ..lib.bl.employees import get_employee_structure
from ..lib.bl.subscriptions import subscribe_resource
from ..lib.utils.security_utils import get_auth_employee
from ..lib.utils.common_utils import translate as _

from ..forms.outgoings import (
    OutgoingForm,
    OutgoingSearchForm,
    OutgoingAssignForm,
)
from ..lib.events.resources import (
    ResourceCreated,
    ResourceChanged,
    ResourceDeleted,
)


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.outgoings.OutgoingsResource',
)
class OutgoingsView(BaseView):

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/outgoings/index.mako',
        permission='view'
    )
    def index(self):
        return {
            'title': self._get_title(),
        }

    @view_config(
        name='list',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        form = OutgoingSearchForm(self.request, self.context)
        form.validate()
        qb = form.submit()
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized()
        }

    @view_config(
        name='view',
        request_method='GET',
        renderer='travelcrm:templates/outgoings/form.mako',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            outgoing = Outgoing.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': outgoing.id}
                )
            )
        result = self.edit()
        result.update({
            'title': self._get_title(_(u'View')),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        request_method='GET',
        renderer='travelcrm:templates/outgoings/form.mako',
        permission='add'
    )
    def add(self):
        auth_employee = get_auth_employee(self.request)
        structure = get_employee_structure(auth_employee)
        return {
            'title': self._get_title(_(u'Add')),
            'structure_id': structure.id
        }

    @view_config(
        name='add',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        form = OutgoingForm(self.request)
        if form.validate():
            outgoing = form.submit()
            DBSession.add(outgoing)
            DBSession.flush()
            event = ResourceCreated(self.request, outgoing)
            event.registry()
            return {
                'success_message': _(u'Saved'),
                'response': outgoing.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='edit',
        request_method='GET',
        renderer='travelcrm:templates/outgoings/form.mako',
        permission='edit'
    )
    def edit(self):
        outgoing = Outgoing.get(self.request.params.get('id'))
        maintainer_structure = get_employee_structure(
            outgoing.resource.maintainer
        )
        return {
            'item': outgoing,
            'structure_id': maintainer_structure.id,
            'title': self._get_title(_(u'Edit')),
        }

    @view_config(
        name='edit',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        outgoing = Outgoing.get(self.request.params.get('id'))
        form = OutgoingForm(self.request)
        if form.validate():
            form.submit(outgoing)
            event = ResourceChanged(self.request, outgoing)
            event.registry()
            return {
                'success_message': _(u'Saved'),
                'response': outgoing.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='copy',
        request_method='GET',
        renderer='travelcrm:templates/outgoings/form.mako',
        permission='add'
    )
    def copy(self):
        outgoing = Outgoing.get(self.request.params.get('id'))
        account_item = outgoing.account_item
        outgoing = Outgoing.get_copy(self.request.params.get('id'))
        outgoing.account_item = account_item
        return {
            'action': self.request.path_url,
            'item': outgoing,
            'title': self._get_title(_(u'Copy')),
        }

    @view_config(
        name='copy',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _copy(self):
        return self._add()

    @view_config(
        name='details',
        request_method='GET',
        renderer='travelcrm:templates/outgoings/details.mako',
        permission='view'
    )
    def details(self):
        outgoing = Outgoing.get(self.request.params.get('id'))
        return {
            'item': outgoing,
        }

    @view_config(
        name='delete',
        request_method='GET',
        renderer='travelcrm:templates/outgoings/delete.mako',
        permission='delete'
    )
    def delete(self):
        return {
            'title': self._get_title(_(u'Delete')),
            'rid': self.request.params.get('rid')
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
                items = DBSession.query(Outgoing).filter(
                    Outgoing.id.in_(ids)
                )
                for item in items:
                    DBSession.delete(item)
                    event = ResourceDeleted(self.request, item)
                    event.registry()
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

    @view_config(
        name='assign',
        request_method='GET',
        renderer='travelcrm:templates/outgoings/assign.mako',
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
        form = OutgoingAssignForm(self.request)
        if form.validate():
            form.submit(self.request.params.getall('id'))
            return {
                'success_message': _(u'Assigned'),
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='subscribe',
        request_method='GET',
        renderer='travelcrm:templates/outgoings/subscribe.mako',
        permission='view'
    )
    def subscribe(self):
        return {
            'id': self.request.params.get('id'),
            'title': self._get_title(_(u'Subscribe')),
        }

    @view_config(
        name='subscribe',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def _subscribe(self):
        ids = self.request.params.getall('id')
        for id in ids:
            outgoing = Outgoing.get(id)
            subscribe_resource(self.request, outgoing.resource)
        return {
            'success_message': _(u'Subscribed'),
        }
