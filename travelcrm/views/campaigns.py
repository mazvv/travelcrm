# -*-coding: utf-8-*-

import logging

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound

from . import BaseView
from ..models import DBSession
from ..models.campaign import Campaign
from ..lib.bl.subscriptions import subscribe_resource
from ..lib.utils.common_utils import translate as _
from ..lib.utils.resources_utils import get_resource_type_by_resource
from ..forms.campaigns import (
    CampaignForm,
    CampaignSearchForm,
    CampaignsSettingsForm,
    CampaignAssignForm,
    CampaignCoverageForm,
)
from ..lib.events.campaigns import (
    CampaignCreated,
    CampaignChanged,
    CampaignDeleted,
)
from ..lib.events.resources import (
    ResourceCreated,
    ResourceChanged,
    ResourceDeleted,
)


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.campaigns.CampaignsResource',
)
class CampaignsView(BaseView):

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/campaigns/index.mako',
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
        form = CampaignSearchForm(self.request, self.context)
        form.validate()
        qb = form.submit()
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized()
        }

    @view_config(
        name='view',
        request_method='GET',
        renderer='travelcrm:templates/campaigns/form.mako',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            campaign = Campaign.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': campaign.id}
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
        renderer='travelcrm:templates/campaigns/form.mako',
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
        form = CampaignForm(self.request)
        if form.validate():
            campaign = form.submit()
            DBSession.add(campaign)
            DBSession.flush()
            event = CampaignCreated(self.request, campaign)
            event.registry()
            event = ResourceCreated(self.request, campaign)
            event.registry()
            return {
                'success_message': _(u'Saved'),
                'response': campaign.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='edit',
        request_method='GET',
        renderer='travelcrm:templates/campaigns/form.mako',
        permission='edit'
    )
    def edit(self):
        campaign = Campaign.get(self.request.params.get('id'))
        return {
            'item': campaign, 
            'title': self._get_title(_(u'Edit')),
        }

    @view_config(
        name='edit',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        campaign = Campaign.get(self.request.params.get('id'))
        form = CampaignForm(self.request)
        if form.validate():
            form.submit(campaign)
            event = CampaignChanged(self.request, campaign)
            event.registry()
            event = ResourceChanged(self.request, campaign)
            event.registry()
            return {
                'success_message': _(u'Saved'),
                'response': campaign.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='copy',
        request_method='GET',
        renderer='travelcrm:templates/campaigns/form.mako',
        permission='add'
    )
    def copy(self):
        campaign = Campaign.get_copy(self.request.params.get('id'))
        return {
            'action': self.request.path_url,
            'item': campaign,
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
        name='delete',
        request_method='GET',
        renderer='travelcrm:templates/campaigns/delete.mako',
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
                items = DBSession.query(Campaign).filter(
                    Campaign.id.in_(ids)
                )
                for item in items:
                    DBSession.delete(item)
                    event = CampaignDeleted(self.request, item)
                    event.registry()
                    event = ResourceDeleted(self.request, item)
                    event.registry()
                DBSession.flush()
            except Exception, e:
                log.error(e)
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
        renderer='travelcrm:templates/campaigns/assign.mako',
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
        form = CampaignAssignForm(self.request)
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
        name='settings',
        request_method='GET',
        renderer='travelcrm:templates/campaigns/settings.mako',
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
        form = CampaignsSettingsForm(self.request)
        if form.validate():
            form.submit()
            return {'success_message': _(u'Saved')}
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='coverage',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _coverage(self):
        form = CampaignCoverageForm(self.request)
        if form.validate():
            return {
                'response': form.submit()
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='subscribe',
        request_method='GET',
        renderer='travelcrm:templates/campaigns/subscribe.mako',
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
            campaign = Campaign.get(id)
            subscribe_resource(self.request, campaign.resource)
        return {
            'success_message': _(u'Subscribed'),
        }
