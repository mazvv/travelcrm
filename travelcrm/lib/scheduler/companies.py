# -*-coding:utf-8-*-

import logging
import transaction

from ...lib.utils.common_utils import get_scheduler, gen_id
from ...lib.utils.companies_utils import create_company_schema


log = logging.getLogger(__name__)


def _company_creation(company_name, timezone, locale):
    with transaction.manager:
        create_company_schema()


def schedule_company_creation(request, company_name, timezone, locale):
    """create new company schema
    """
    scheduler = get_scheduler(request)
    scheduler.add_job(
        _company_creation,
        id=gen_id(limit=12),
        args=[company_name, timezone, locale],
    )
