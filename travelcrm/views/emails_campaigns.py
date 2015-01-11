# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.email_campaign import EmailCampaign
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.emails_campaigns import EmailsCampaignsQueryBuilder
from ..lib.utils.resources_utils import get_resource_type_by_resource
from ..lib.utils.common_utils import translate as _
from ..lib.scheduler.emails_campaigns import schedule_email_campaign

from ..forms.emails_campaigns import (
    EmailCampaignSchema,
    EmailCampaignSearchSchema,
    SettingsSchema
)


log = logging.getLogger(__name__)


class EmailsCampaigns(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.emails_campaigns.EmailsCampaigns',
        request_method='GET',
        renderer='travelcrm:templates/emails_campaigns/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.emails_campaigns.EmailsCampaigns',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        schema = EmailCampaignSearchSchema().bind(request=self.request)
        controls = schema.deserialize(self.request.params.mixed())
        qb = EmailsCampaignsQueryBuilder(self.context)
        qb.search_simple(controls.get('q'))
        qb.advanced_search(**controls)
        id = self.request.params.get('id')
        if id:
            qb.filter_id(id.split(','))
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
        name='view',
        context='..resources.emails_campaigns.EmailsCampaigns',
        request_method='GET',
        renderer='travelcrm:templates/emails_campaigns/form.mak',
        permission='view'
    )
    def view(self):
        result = self.edit()
        result.update({
            'title': _(u"View Email Campaign"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        context='..resources.emails_campaigns.EmailsCampaigns',
        request_method='GET',
        renderer='travelcrm:templates/emails_campaigns/form.mak',
        permission='add'
    )
    def add(self):
        return {'title': _(u'Add Email Campaign')}

    @view_config(
        name='add',
        context='..resources.emails_campaigns.EmailsCampaigns',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        schema = EmailCampaignSchema().bind(request=self.request)

        try:
            controls = schema.deserialize(self.request.params.mixed())
            email_campaign = EmailCampaign(
                name=controls.get('name'),
                subject=controls.get('subject'),
                plain_content=controls.get('plain_content'),
                html_content=controls.get('html_content'),
                start_dt=controls.get('start_dt'),
                resource=self.context.create_resource()
            )
            for id in controls.get('note_id'):
                note = Note.get(id)
                email_campaign.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                email_campaign.resource.tasks.append(task)
            DBSession.add(email_campaign)
            DBSession.flush()
            schedule_email_campaign(self.request, email_campaign.id)
            return {
                'success_message': _(u'Saved'),
                'response': email_campaign.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.emails_campaigns.EmailsCampaigns',
        request_method='GET',
        renderer='travelcrm:templates/emails_campaigns/form.mak',
        permission='edit'
    )
    def edit(self):
        email_campaign = EmailCampaign.get(self.request.params.get('id'))
        return {'item': email_campaign, 'title': _(u'Edit EmailCampaign')}

    @view_config(
        name='edit',
        context='..resources.emails_campaigns.EmailsCampaigns',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        schema = EmailCampaignSchema().bind(request=self.request)
        email_campaign = EmailCampaign.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params.mixed())
            email_campaign.name = controls.get('name')
            email_campaign.subject = controls.get('subject')
            email_campaign.plain_content = controls.get('plain_content')
            email_campaign.html_content = controls.get('html_content')
            email_campaign.start_dt = controls.get('start_dt')

            email_campaign.addresses = []
            email_campaign.resource.notes = []
            email_campaign.resource.tasks = []
            for id in controls.get('note_id'):
                note = Note.get(id)
                email_campaign.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                email_campaign.resource.tasks.append(task)
            schedule_email_campaign(self.request, email_campaign.id)
            return {
                'success_message': _(u'Saved'),
                'response': email_campaign.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='delete',
        context='..resources.emails_campaigns.EmailsCampaigns',
        request_method='GET',
        renderer='travelcrm:templates/emails_campaigns/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete EmailCampaigns'),
            'rid': self.request.params.get('rid')
        }

    @view_config(
        name='delete',
        context='..resources.emails_campaigns.EmailsCampaigns',
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

    @view_config(
        name='settings',
        context='..resources.emails_campaigns.EmailsCampaigns',
        request_method='GET',
        renderer='travelcrm:templates/emails_campaigns/settings.mak',
        permission='settings',
    )
    def settings(self):
        rt = get_resource_type_by_resource(self.context)
        return {
            'title': _(u'Settings'),
            'rt': rt,
        }

    @view_config(
        name='settings',
        context='..resources.emails_campaigns.EmailsCampaigns',
        request_method='POST',
        renderer='json',
        permission='settings',
    )
    def _settings(self):
        schema = SettingsSchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params)
            rt = get_resource_type_by_resource(self.context)
            rt.settings = {'timeout': controls.get('timeout')}
            return {'success_message': _(u'Saved')}
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }
