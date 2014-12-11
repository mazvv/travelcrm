#-*-coding:utf-8-*-

from pytz import timezone

from apscheduler.schedulers.background import BackgroundScheduler
from apscheduler.jobstores.sqlalchemy import SQLAlchemyJobStore
from apscheduler.executors.pool import ProcessPoolExecutor


scheduler = BackgroundScheduler()


def includeme(config):
    settings = config.registry.settings
    jobstores = {
        'default': SQLAlchemyJobStore(url=settings['scheduler.url'])
    }
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
