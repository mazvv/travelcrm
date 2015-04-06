# -*-coding: utf-8 -*-
import logging
from pytz import timezone

from apscheduler.schedulers.background import BackgroundScheduler
from apscheduler.jobstores.sqlalchemy import SQLAlchemyJobStore
from apscheduler.executors.pool import ProcessPoolExecutor

from pyramid.httpexceptions import HTTPNotFound

import lib.helpers as h
from .lib.utils.common_utils import translate as _
from .lib.bl.employees import get_employee_structure
from .lib.utils.security_utils import get_auth_employee
from .lib.utils.sql_utils import (
    get_default_schema,
    get_schemas,
    set_search_path
)
from .interfaces import IScheduler


log = logging.getLogger(__name__)


def helpers(event):
    event.update({'h': h, '_': _})


def company_settings(event):
    request = event.request
    employee = get_auth_employee(request)
    if not employee:
        return
    structure = get_employee_structure(employee)
    company = structure.company
    if company:
        settings = {
            'company.name': company.name,
            'company.base_currency': company.currency.iso_code,
            'company.locale_name': company.settings.get('locale'),
        }
        request.registry.settings.update(settings)


def company_schema(event):
    request = event.request
    domain_parts = request.domain.split('.', 1)
    schema_name = get_default_schema()
#    if len(domain_parts) > 1:
#        schema_name = domain_parts[0]
#        schemas = get_schemas()
#        if schema_name not in schemas:
#            raise HTTPNotFound()
    set_search_path(schema_name)


def scheduler(event):
    scheduler = BackgroundScheduler()
    settings = event.app.registry.settings
    jobstores = {'default': SQLAlchemyJobStore(url=settings['scheduler.url'])}
    executors = {
        'default': {
            'type': settings['scheduler.executors.type'],
            'max_workers': settings['scheduler.executors.max_workers']
        },
        'processpool': ProcessPoolExecutor(
            max_workers=settings['scheduler.executors.processpool.max_workers']
        )
    }
    job_defaults = {
        'coalesce': False,
        'max_instances': settings['scheduler.job_defaults.max_instances']
    }
    scheduler.configure(
        jobstores=jobstores,
        executors=executors,
        job_defaults=job_defaults,
        timezone=timezone(settings['date.timezone'])
    )
    if settings['scheduler.autostart'] == 'true':
        scheduler.start()
    event.app.registry.registerUtility(scheduler, IScheduler)
