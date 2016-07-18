# -*-coding:utf-8-*-

import logging
import transaction

import pytz

from ...resources.notifications import NotificationsResource
from ...models.task import Task
from ...models.resource import Resource
from ...models.notification import Notification
from ...lib.scheduler import scheduler
from ...lib.bl.employees import get_employee_structure
from ...lib.utils.scheduler_utils import scopped_task, gen_task_id


log = logging.getLogger(__name__)


@scopped_task
def _task_notification(task_id):
    with transaction.manager:
        task = Task.get(task_id)
        if task:
            employee_structure = get_employee_structure(
                task.resource.maintainer
            )
            notification = Notification(
                title=task.title,
                descr=task.title,
                notification_resource=task.resource,
                resource=Resource(NotificationsResource, employee_structure)
            )
            task.employee.notifications.append(notification)


def schedule_task_notification(request, task_id):
    """add notification for task
    """
    task = Task.get(task_id)
    run_date = task.reminder_datetime.astimezone(pytz.utc)
    scheduler.add_job(
        _task_notification,
        trigger='date',
        id=gen_task_id(),
        replace_existing=True,
        run_date=run_date.replace(tzinfo=None),
        args=[task.id],
    )
