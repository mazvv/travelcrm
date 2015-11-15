#-*-coding:utf-8-*-

from pyramid.events import subscriber

from ..events.campaigns import (
    CampaignCreated,
) 
from ..scheduler.campaigns import (
    schedule_campaign,
)


@subscriber(CampaignCreated)
def campaign_created(event):
    schedule_campaign(event.campaign.id)
