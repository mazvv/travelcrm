#-*-coding:utf-8-*-

from pyramid.events import subscriber

from ..events.campaigns import (
    CampaignCreated,
    CampaignEdited,
    CampaignDeleted,
    CampaignAssigned,
) 
from ..scheduler.campaigns import (
    schedule_campaign, remove_job
)
from ..scheduler.notifications import add_notification
from ..utils.common_utils import translate as _


@subscriber(CampaignCreated)
def campaign_created(event):
    descr = _(u'New campaign "%s" created') % event.obj.name
    add_notification(descr, event.obj.resource_id)
    schedule_campaign(event.obj.id)


@subscriber(CampaignEdited)
def campaign_edited(event):
    descr = _(u'Campaign "%s" was changed') % event.obj.name
    add_notification(descr, event.obj.resource_id)
    schedule_campaign(event.obj.id)


@subscriber(CampaignDeleted)
def campaign_deleted(event):
    descr = _(u'Campaign "%s" was deleted') % event.obj.name
    add_notification(descr, event.obj.id)
    remove_job(event.obj.id)


@subscriber(CampaignAssigned)
def campaign_assigned(event):
    descr = _(u'Campaign "%s" was assigned to you') % event.obj.name
    add_notification(descr, event.obj.id)
