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
    bucket, gen_task_id, scopped_task, transactional
)


log = logging.getLogger(__name__)

BUCKET_SIZE = 10


def _gen_task_id(campaign_id):
    return gen_task_id('camp' + str(campaign_id))


@scopped_task
@transactional
def _send_message(campaign_id, contacts):
    campaign = Campaign.get(campaign_id)
    mailer = get_mailer()
    for email in contacts:
        log.info('Send email to %s' % email)
        message = Message(
            subject=campaign.mail.subject,
            recipients=(email,),
            html=campaign.mail.html_content
        )
        try:
            mailer.send_immediately(message)
        except Exception as e:
            log.exception(e)
    campaign.set_status_ready()


@bucket(BUCKET_SIZE)
def schedule_campaign(campaign_id):
    """ for task we set suffix manualy for replace it
    """
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
        id=_gen_task_id(campaign_id),
        replace_existing=False,
        run_date=campaign.start_dt,
        args=[campaign_id, contacts],
    )


def remove_job(campaign_id):
    job_id = _gen_task_id(campaign_id)
    if scheduler.get_job(job_id):
        scheduler.remove_job(_gen_task_id(campaign_id))
