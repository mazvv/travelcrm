# -*-coding:utf-8-*-

import logging
import transaction
from datetime import datetime

import pytz

from ...models import DBSession
from ...models.company import Company
from ...lib.utils.common_utils import get_scheduler, gen_id
from ...lib.utils.companies_utils import create_company_schema


log = logging.getLogger(__name__)


def _company_creation(company_name, email, timezone, locale):
    
    with transaction.manager:
        create_company_schema()
        company = Company(
            name=company_name,
            email=email,
            settings = {
                'timezone': timezone,
                'locale': locale,
            }
        )
        DBSession.add(company)


def schedule_company_creation(request, company_name, email, timezone, locale):
    """create new company schema
    """
    scheduler = get_scheduler(request)
    scheduler.add_job(
        _company_creation,
        trigger='date',
        id=gen_id(limit=12),
        run_date=datetime.now(pytz.utc),
        args=[company_name, email, timezone, locale],
    )
