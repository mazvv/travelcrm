# -*-coding:utf-8-*-

import logging
import transaction
from datetime import datetime

import pytz

from ...resources.notifications import NotificationsResource
from ...models.resource import Resource
from ...models.notification import Notification
from ...lib.scheduler import scheduler
from ...lib.utils.scheduler_utils import (
    scopped_task,
    after_commit,
    gen_task_id
)


log = logging.getLogger(__name__)


@scopped_task
def _add_notification(descr, resource_id):
    with transaction.manager:
        resource = Resource.get(resource_id)
        if not resource:
            log.error(
                u'Can\'t create notification for resource #%s, its not exists'
                % resource_id
            )
            return
        notification = Notification(
            descr=descr,
            notification_resource=resource,
            resource=Resource(NotificationsResource, resource.maintainer)
        )
        for subscriber in resource.subscribers:
            subscriber.notifications.append(notification)
        log.info(u'Create notification for resource #%s' % resource_id)


@after_commit
def add_notification(descr, resource_id, dt=None):
    scheduler.add_job(
        _add_notification,
        id=gen_task_id(),
        trigger='date',
        replace_existing=True,
        run_date=(dt or datetime.now(pytz.utc)),
        args=[descr, resource_id],
    )
