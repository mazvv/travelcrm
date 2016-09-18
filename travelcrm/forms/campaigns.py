# -*-coding: utf-8 -*-

from datetime import datetime

import colander

from . import(
    DateTime,
    SelectInteger,
    ResourceSchema, 
    BaseForm,
    BaseSearchForm,
    BaseAssignForm,
)
from ..resources.campaigns import CampaignsResource
from ..models.campaign import Campaign
from ..models.mail import Mail
from ..models.person_category import PersonCategory
from ..models.tag import Tag
from ..models.note import Note
from ..models.task import Task
from ..lib.bl.campaigns import query_coverage
from ..lib.qb.campaigns import CampaignsQueryBuilder
from ..lib.utils.common_utils import parse_datetime
from ..lib.utils.resources_utils import get_resource_type_by_resource
from ..lib.utils.security_utils import get_auth_employee
from ..lib.utils.common_utils import translate as _


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


@colander.deferred
def status_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        campaign_id = request.params.get('id')
        campaign = Campaign.get(campaign_id)
        if value not in ('ready', 'in_work'):
            return
        if not campaign or (
            campaign and not campaign.is_status_ready()
            and not campaign.is_status_in_work()
        ):
            raise colander.Invalid(
                node,
                _(u'This is automatic status, can\'t set it manualy'),
            )
    return validator


class _CampaignSchema(ResourceSchema):
    MAX_TAGS = 10
    name = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=32),
    )
    start_dt = colander.SchemaNode(
        DateTime(),
        validators=start_dt_validator
    )
    mail_id = colander.SchemaNode(
        SelectInteger(Mail),
    )
    person_category_id = colander.SchemaNode(
        SelectInteger(PersonCategory),
        missing=None,
    )
    tag_id = colander.SchemaNode(
        colander.Set(),
        validator=colander.Length(
            max=MAX_TAGS, max_err=_(u'Max %s tags allowed') % MAX_TAGS
        ),
        missing=[],
    )
    status = colander.SchemaNode(
        colander.String(),
        validator=status_validator
    )

    def deserialize(self, cstruct):
        if (
            'tag_id' in cstruct
            and not isinstance(cstruct.get('tag_id'), list)
        ):
            val = cstruct['tag_id']
            cstruct['tag_id'] = list()
            cstruct['tag_id'].append(val)

        return super(_CampaignSchema, self).deserialize(cstruct)


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


class _CampaignCoverageSchema(ResourceSchema):
    person_category_id = colander.SchemaNode(
        SelectInteger(PersonCategory),
        missing=None,
    )
    tag_id = colander.SchemaNode(
        colander.Set(),
        missing=[],
    )

    def deserialize(self, cstruct):
        if (
            'tag_id' in cstruct
            and not isinstance(cstruct.get('tag_id'), list)
        ):
            val = cstruct['tag_id']
            cstruct['tag_id'] = list()
            cstruct['tag_id'].append(val)

        return super(_CampaignCoverageSchema, self).deserialize(cstruct)


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
            campaign.resource.tags = []
            campaign.resource.notes = []
            campaign.resource.tasks = []
        campaign.name = self._controls.get('name')
        campaign.mail_id = self._controls.get('mail_id')
        campaign.person_category_id = self._controls.get('person_category_id')
        campaign.start_dt = self._controls.get('start_dt')
        campaign.status = self._controls.get('status')
        for id in self._controls.get('tag_id'):
            tag = Tag.get(id)
            campaign.resource.tags.append(tag)
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


class CampaignCoverageForm(BaseForm):
    _schema = _CampaignCoverageSchema

    def submit(self):
        person_category_id = self._controls.get('person_category_id') or []
        if person_category_id:
            person_category_id = [person_category_id]
        tag_id = self._controls.get('tag_id') or []
        return query_coverage(person_category_id, tag_id).count()
