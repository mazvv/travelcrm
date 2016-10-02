#-*-coding:utf-8-*-

from pyramid.events import subscriber

from ..events.tasks import TaskCreated
 
from ..bl.subscriptions import subscribe_resource
from ..scheduler.notifications import add_notification


@subscriber(TaskCreated)
def resource_created(event):
    subscribe_resource(event.request, event.obj.resource)
    add_notification(
        event.descr, event.obj.resource_id, event.obj.reminder_datetime
    )
