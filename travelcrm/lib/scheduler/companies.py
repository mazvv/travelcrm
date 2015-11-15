# -*-coding:utf-8-*-

import logging
import transaction
from functools import partial
from datetime import datetime

import pytz
from apscheduler.events import EVENT_JOB_EXECUTED, EVENT_JOB_ERROR
from pyramid_mailer import mailer_factory_from_settings
from pyramid_mailer.message import Message
from pyramid.renderers import render

from ...models import DBSession
from ...models.company import Company
from ...lib.scheduler import scheduler
from ...lib.utils.common_utils import gen_id
from ...lib.utils.companies_utils import (
    create_company_schema, generate_company_schema
)
from ...lib.utils.common_utils import translate as _


log = logging.getLogger(__name__)


def _company_creation(company_name, schema_name, email, timezone, locale):
    with transaction.manager:
        schema_name = create_company_schema(schema_name)
        company = DBSession.query(Company).first()
        company.name = company_name
        company.email = email
        company.settings = {
            'timezone': timezone,
            'locale': locale,
        }
        DBSession.add(company)


def _notification_callback(
    event, job_id, request, email, subdomain
):
    if event.job_id != job_id:
        return

    if event.code == EVENT_JOB_EXECUTED:
        subject = _(u'Company created')
        html = render(
            'travelcrm:templates/companies/email_success.mako',
            {'subdomain': subdomain},
            request=request,
        )

    mailer = mailer_factory_from_settings(request.registry.settings)
    message = Message(
        subject=subject,
        sender=mailer.default_sender,
        recipients=(email,),
        html=html
    )
    mailer.send_immediately(message)
    scheduler.remove_listener(_notification_callback)
    

def schedule_company_creation(request, company_name, email, timezone, locale):
    """create new company schema
    """
    job_id = gen_id(limit=12)
    schema_name = generate_company_schema()
    scheduler.add_job(
        _company_creation,
        trigger='date',
        id=job_id,
        run_date=datetime.now(pytz.utc),
        args=[company_name, schema_name, email, timezone, locale],
    )

    
    callback = partial(
        _notification_callback, job_id=job_id, 
        request=request, email=email, subdomain=schema_name
    )
    scheduler.add_listener(callback, EVENT_JOB_EXECUTED | EVENT_JOB_ERROR)
