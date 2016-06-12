# -*-coding:utf-8-*-

import logging
from datetime import datetime

import pytz

from ...models import DBSession
from ...models.resource import Resource

from ...lib.scheduler import scheduler
from ...lib.utils.scheduler_utils import (
    gen_task_id, scopped_task, transactional
)


log = logging.getLogger(__name__)

BUCKET_SIZE = 100


@scopped_task
@transactional
def _assign(resources_ids, new_maintainer_id):
    log.info('Resources to proceed: %s' % ', '.join(map(str, resources_ids)))
    for id in resources_ids:
        resource = Resource.get(id)
        log.info(
            'Change maintainer of rid %s: %s -> %s'
            % (resource.id, resource.maintainer_id, new_maintainer_id)
        )
        resource.maintainer_id = new_maintainer_id


@scopped_task
def _assigns(from_employee_id, to_employee_id):
    def _task(ids):
        scheduler.add_job(
            _assign,
            trigger='date',
            id=gen_task_id(),
            replace_existing=True,
            run_date=datetime.now(pytz.utc),
            args=[ids, to_employee_id],
        )

    resources = (
        DBSession.query(Resource)
        .filter(
            Resource.maintainer_id == from_employee_id,
        )
        .order_by(Resource.id)
    )
    i = 0
    ids = []
    for resource in resources:
        i += 1
        ids.append(resource.id)
        if not i % BUCKET_SIZE:
            _task(ids)
            ids = []
    if ids:
        _task(ids)


def schedule_assign(from_employee_id, to_employee_id):
    scheduler.add_job(
        _assigns,
        trigger='date',
        id=gen_task_id(),
        replace_existing=True,
        run_date=datetime.now(pytz.utc),
        args=[from_employee_id, to_employee_id],
    )
    