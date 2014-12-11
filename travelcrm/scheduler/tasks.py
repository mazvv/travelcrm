#-*-coding:utf-8-*-

from . import scheduler
from ..models.task import Task


def _task_notification(task_id):
    print ">>>>>>>>>>>>>>>>>>>>", task_id


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
