# -*-coding: utf-8 -*-

from datetime import datetime

import colander

from . import(
    DateTime,
    ResourceSchema, 
    BaseForm,
    BaseSearchForm,
)
from ..resources.campaigns import CampaignsResource
from ..models.campaign import Campaign
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.campaigns import CampaignsQueryBuilder
from ..lib.utils.common_utils import parse_datetime
from ..lib.utils.resources_utils import get_resource_type_by_resource


@colander.deferred
def start_dt_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        campaign_id = request.params.get('id')
        if campaign_id:
            return
        if parse_datetime(value) <= datetime.now():
            raise colander.Invalid(
                node,
                _(u'Check datetime'),
            )
    return colander.All(colander.Length(max=255), validator,)


class _CampaignSchema(ResourceSchema):
    name = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=32),
    )
    subject = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=128),
    )
    plain_content = colander.SchemaNode(
        colander.String(),
    )
    html_content = colander.SchemaNode(
        colander.String(),
    )
    start_dt = colander.SchemaNode(
        DateTime(),
        validators=start_dt_validator
    )


class _SettingsSchema(colander.Schema):
    host = colander.SchemaNode(
        colander.String(),
    )
    port = colander.SchemaNode(
        colander.String(),
    )
    username = colander.SchemaNode(
        colander.String(),
    )
    password = colander.SchemaNode(
        colander.String(),
    )
    default_sender = colander.SchemaNode(
        colander.String(),
        validators=colander.All(colander.Email())
    )


class CampaignForm(BaseForm):
    _schema = _CampaignSchema

    def submit(self, email_campaign=None):
        context = CampaignsResource(self.request)
        if not email_campaign:
            email_campaign = Campaign(
                resource=context.create_resource()
            )
        else:
            email_campaign.resource.notes = []
            email_campaign.resource.tasks = []
        email_campaign.name = self._controls.get('name')
        email_campaign.subject = self._controls.get('subject')
        email_campaign.plain_content = self._controls.get('plain_content')
        email_campaign.html_content = self._controls.get('html_content')
        email_campaign.start_dt = self._controls.get('start_dt')
        for id in self._controls.get('note_id'):
            note = Note.get(id)
            email_campaign.resource.notes.append(note)
        for id in self._controls.get('task_id'):
            task = Task.get(id)
            email_campaign.resource.tasks.append(task)
        return email_campaign


class CampaignSearchForm(BaseSearchForm):
    _qb = CampaignsQueryBuilder


class CampaignsSettingsForm(BaseForm):
    _schema = _SettingsSchema

    def submit(self):
        context = CampaignsResource(self.request)
        rt = get_resource_type_by_resource(context)
        rt.settings = {
            'host': self._controls.get('host'),
            'port': self._controls.get('port'),
            'username': self._controls.get('username'),
            'password': self._controls.get('password'),
            'default_sender': self._controls.get('default_sender'),
        }
