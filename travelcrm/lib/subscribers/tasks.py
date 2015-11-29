#-*-coding:utf-8-*-

from pyramid.events import subscriber

from ..events.tasks import TaskCreated 
from ..scheduler.tasks import schedule_task_notification


@subscriber(TaskCreated)
def task_created(event):
    schedule_task_notification(event.request, event.task.id)
