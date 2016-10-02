# -*-coding: utf-8-*-

import logging

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound

from . import BaseView
from ..resources.orders import OrdersResource
from ..models import DBSession
from ..models.lead import Lead
from ..lib.bl.subscriptions import subscribe_resource
from ..lib.bl.leads import get_lead_copy
from ..lib.utils.common_utils import translate as _
from ..forms.leads import (
    LeadForm, 
    LeadSearchForm,
    LeadAssignForm,
)
from ..lib.events.resources import (
    ResourceCreated,
    ResourceChanged,
    ResourceDeleted,
)


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.leads.LeadsResource',
)
class LeadsView(BaseView):

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/leads/index.mako',
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
        form = LeadSearchForm(self.request, self.context)
        form.validate()
        qb = form.submit()
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized()
        }

    @view_config(
        name='view',
        request_method='GET',
        renderer='travelcrm:templates/leads/form.mako',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            lead = Lead.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': lead.id}
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
        renderer='travelcrm:templates/leads/form.mako',
        permission='add'
    )
    def add(self):
        return {
            'title': self._get_title(_(u'Add')),
        }

    @view_config(
        name='add',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        form = LeadForm(self.request)
        if form.validate():
            lead = form.submit()
            DBSession.add(lead)
            DBSession.flush()
            event = ResourceCreated(self.request, lead)
            event.registry()
            return {
                'success_message': _(u'Saved'),
                'response': lead.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='edit',
        request_method='GET',
        renderer='travelcrm:templates/leads/form.mako',
        permission='edit'
    )
    def edit(self):
        lead = Lead.get(self.request.params.get('id'))
        return {
            'item': lead, 
            'title': self._get_title(_(u'Edit')),
        }

    @view_config(
        name='edit',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        lead = Lead.get(self.request.params.get('id'))
        form = LeadForm(self.request)
        if form.validate():
            form.submit(lead)
            event = ResourceChanged(self.request, lead)
            event.registry()
            return {
                'success_message': _(u'Saved'),
                'response': lead.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='copy',
        request_method='GET',
        renderer='travelcrm:templates/leads/form.mako',
        permission='add'
    )
    def copy(self):
        lead = get_lead_copy(self.request.params.get('id'), self.request)
        return {
            'action': self.request.path_url,
            'item': lead,
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
        renderer='travelcrm:templates/leads/details.mako',
        permission='view'
    )
    def details(self):
        lead = Lead.get(self.request.params.get('id'))
        return {
            'item': lead,
        }

    @view_config(
        name='order',
        request_method='GET',
        permission='order'
    )
    def order(self):
        lead = Lead.get(self.request.params.get('id'))
        if lead:
            return HTTPFound(
                location = self.request.resource_url(
                    OrdersResource(self.request),
                    'add' if not lead.order else 'edit',
                    query={
                        'id': lead.id 
                        if not lead.order 
                        else lead.order.id
                    }
                )
            )

    @view_config(
        name='delete',
        request_method='GET',
        renderer='travelcrm:templates/leads/delete.mako',
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
                items = DBSession.query(Lead).filter(Lead.id.in_(ids))
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
        renderer='travelcrm:templates/leads/assign.mako',
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
        form = LeadAssignForm(self.request)
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
        renderer='travelcrm:templates/leads/subscribe.mako',
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
            lead = Lead.get(id)
            subscribe_resource(self.request, lead.resource)
        return {
            'success_message': _(u'Subscribed'),
        }
