# -*-coding: utf-8 -*-

from datetime import datetime

import colander

from . import(
    DateTime,
    ResourceSchema, 
    BaseForm,
    BaseSearchForm,
    BaseAssignForm,
)
from ..resources.campaigns import CampaignsResource
from ..models.campaign import Campaign
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.campaigns import CampaignsQueryBuilder
from ..lib.utils.common_utils import parse_datetime
from ..lib.utils.resources_utils import get_resource_type_by_resource
from ..lib.utils.security_utils import get_auth_employee


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
    status = colander.SchemaNode(
        colander.String(),
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

    def submit(self, campaign=None):
        if not campaign:
            campaign = Campaign(
                resource=CampaignsResource.create_resource(
                    get_auth_employee(self.request)
                )
            )
        else:
            campaign.resource.notes = []
            campaign.resource.tasks = []
        campaign.name = self._controls.get('name')
        campaign.subject = self._controls.get('subject')
        campaign.plain_content = self._controls.get('plain_content')
        campaign.html_content = self._controls.get('html_content')
        campaign.start_dt = self._controls.get('start_dt')
        campaign.status = self._controls.get('status')
        for id in self._controls.get('note_id'):
            note = Note.get(id)
            campaign.resource.notes.append(note)
        for id in self._controls.get('task_id'):
            task = Task.get(id)
            campaign.resource.tasks.append(task)
        return campaign


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


class CampaignAssignForm(BaseAssignForm):
    def submit(self, ids):
        for id in ids:
            campaign = Campaign.get(id)
            campaign.resource.maintainer_id = self._controls.get(
                'maintainer_id'
            )
