# -*-coding:utf-8-*-

import logging
import transaction

from . import scheduler
from ..resources.notifications import Notifications

from ..models.task import Task
from ..models.resource import Resource
from ..models.notification import Notification
from ..lib.bl.employees import get_employee_structure
from ..lib.utils.common_utils import translate as _

log = logging.getLogger(__name__)


def _task_notification(task_id):
    with transaction.manager:
        task = Task.get(task_id)
        if task:
            employee_structure = get_employee_structure(task.employee)
            notification = Notification(
                title=_(u'A reminder of the task #%s') % task.id,
                descr=_(u'Do not forget about task!'),
                resource=Resource(Notifications, employee_structure)
            )
            task.employee.notifications.append(notification)
            log.info(u'Notification for task #%s' % task.id)


def schedule_task_notification(task_id):
    id = "%s-%s" % (_task_notification.__name__, task_id)
    task = Task.get(task_id)
    scheduler.add_job(
        _task_notification,
        trigger='date',
        id=id,
        replace_existing=True,
        run_date=task.reminder,
        args=[task.id],
    )
