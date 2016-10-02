#-*-coding:utf-8-*-

from pyramid.events import subscriber

from ..events.campaigns import (
    CampaignCreated,
    CampaignChanged,
    CampaignDeleted,
) 
from ..scheduler.campaigns import (
    schedule_campaign, remove_job
)


@subscriber(CampaignCreated)
def campaign_created(event):
    schedule_campaign(event.obj.id)


@subscriber(CampaignChanged)
def campaign_changed(event):
    remove_job(event.obj.id)
    schedule_campaign(event.obj.id)


@subscriber(CampaignDeleted)
def campaign_deleted(event):
    remove_job(event.obj.id)
