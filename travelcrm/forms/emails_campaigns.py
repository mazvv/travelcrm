# -*-coding: utf-8 -*-

import colander

from . import(
    DateTime,
    ResourceSchema, 
    BaseForm,
    BaseSearchForm,
)
from ..resources.emails_campaigns import EmailsCampaignsResource
from ..models.email_campaign import EmailCampaign
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.emails_campaigns import EmailsCampaignsQueryBuilder


class _EmailCampaignSchema(ResourceSchema):
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
    )


class SettingsSchema(colander.Schema):
    timeout = colander.SchemaNode(
        colander.Integer(),
        default=10
    )


class EmailCampaignForm(BaseForm):
    _schema = _EmailCampaignSchema

    def submit(self, bank=None):
        context = EmailsCampaignsResource(self.request)
        if not bank:
            email_campaign = EmailCampaign(
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


class EmailCampaignSearchForm(BaseSearchForm):
    _qb = EmailsCampaignsQueryBuilder
