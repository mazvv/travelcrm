# -*-coding:utf-8-*-

import logging

from pyramid_mailer.message import Message

from ...models import DBSession
from ...models.campaign import Campaign
from ...models.contact import Contact
from ...models.person import Person

from ...lib.scheduler import scheduler
from ...lib.bl.campaigns import get_mailer
from ...lib.utils.scheduler_utils import (
    bucket, gen_task_id, scopped_task
)


log = logging.getLogger(__name__)

BUCKET_SIZE = 10


@scopped_task
def _send_message(campaign_id, contacts):
    campaign = Campaign.get(campaign_id)
    mailer = get_mailer()
    for email in contacts:
        message = Message(
            subject=campaign.subject,
            recipients=(email,),
            html=campaign.html_content
        )
        mailer.send_immediately(message)
    campaign.set_status_ready()


@bucket(BUCKET_SIZE)
def schedule_campaign(campaign_id):
    campaign = Campaign.get(campaign_id)
    contacts = yield (
        DBSession.query(Contact.contact.label('contact'))
        .join(Person, Contact.person)
        .filter(
            Contact.condition_email(),
            Contact.condition_status_active(),
            Person.condition_email_subscribtion()
        )
        .order_by(Contact.id)
    )
    contacts = tuple(contact.contact for contact in contacts)
    scheduler.add_job(
        _send_message,
        trigger='date',
        id=gen_task_id(),
        replace_existing=True,
        run_date=campaign.start_dt,
        args=[campaign_id, contacts],
    )
