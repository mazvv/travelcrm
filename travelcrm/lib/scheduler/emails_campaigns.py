# -*-coding:utf-8-*-

from datetime import timedelta
import logging

from pyramid_mailer import mailer_factory_from_settings
from pyramid_mailer.message import Message

from ...resources.emails_campaigns import EmailsCampaigns
from ...models.email_campaign import EmailCampaign
from ...lib.bl.emails_campaigns import get_all_subscribers
from ...lib.utils.resources_utils import get_resource_type_by_resource_cls
from ...lib.utils.common_utils import gen_id, get_scheduler


log = logging.getLogger(__name__)


def _send(settings, subject, recepient, body, html):
    mailer = mailer_factory_from_settings(settings)
    message = Message(
        subject=subject,
        sender=mailer.default_sender,
        recipients=(recepient,),
        body=body,
        html=html
    )
    mailer.send_immediately(message)


def schedule_email_campaign(request, email_campaign_id):
    campaign = EmailCampaign.get(email_campaign_id)
    subscribers = get_all_subscribers()
    rt = get_resource_type_by_resource_cls(EmailsCampaigns)
    start_dt = campaign.start_dt
    scheduler = get_scheduler(request)

    for name, email in subscribers:
        id = gen_id()
        scheduler.add_job(
            _send,
            trigger='date',
            id=id,
            replace_existing=True,
            run_date=start_dt,
            args=[
                request.registry.settings,
                campaign.subject,
                email,
                campaign.plain_content,
                campaign.html_content
            ],
        )
        start_dt = start_dt + timedelta(seconds=rt.settings.get('timeout'))
