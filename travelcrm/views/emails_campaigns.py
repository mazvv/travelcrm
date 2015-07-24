# -*-coding: utf-8-*-

import logging

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound

from . import BaseView
from ..models import DBSession
from ..models.email_campaign import EmailCampaign
from ..lib.utils.common_utils import translate as _
from ..lib.scheduler.emails_campaigns import schedule_email_campaign

from ..forms.emails_campaigns import (
    EmailCampaignForm,
    EmailCampaignSearchForm,
)


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.emails_campaigns.EmailsCampaignsResource',
)
class EmailsCampaignsView(BaseView):

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/emails_campaigns/index.mako',
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
        form = EmailCampaignSearchForm(self.request, self.context)
        form.validate()
        qb = form.submit()
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized()
        }

    @view_config(
        name='view',
        request_method='GET',
        renderer='travelcrm:templates/emails_campaigns/form.mako',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            email_campaign = EmailCampaign.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': email_campaign.id}
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
        renderer='travelcrm:templates/emails_campaigns/form.mako',
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
        form = EmailCampaignForm(self.request)
        if form.validate():
            email_campaign = form.submit()
            DBSession.add(email_campaign)
            DBSession.flush()
            schedule_email_campaign(self.request, email_campaign.id)
            return {
                'success_message': _(u'Saved'),
                'response': email_campaign.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='edit',
        request_method='GET',
        renderer='travelcrm:templates/emails_campaigns/form.mako',
        permission='edit'
    )
    def edit(self):
        email_campaign = EmailCampaign.get(self.request.params.get('id'))
        return {
            'item': email_campaign, 
            'title': self._get_title(_(u'Edit')),
        }

    @view_config(
        name='edit',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        email_campaign = EmailCampaign.get(self.request.params.get('id'))
        form = EmailCampaignForm(self.request)
        if form.validate():
            form.submit(email_campaign)
            schedule_email_campaign(self.request, email_campaign.id)
            return {
                'success_message': _(u'Saved'),
                'response': email_campaign.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='delete',
        request_method='GET',
        renderer='travelcrm:templates/emails_campaigns/delete.mako',
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
        errors = 0
        for id in self.request.params.getall('id'):
            item = EmailCampaign.get(id)
            if item:
                DBSession.begin_nested()
                try:
                    DBSession.delete(item)
                    DBSession.commit()
                except:
                    errors += 1
                    DBSession.rollback()
        if errors > 0:
            return {
                'error_message': _(
                    u'Some objects could not be delete'
                ),
            }
        return {'success_message': _(u'Deleted')}
