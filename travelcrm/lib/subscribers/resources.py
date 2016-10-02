#-*-coding:utf-8-*-

from pyramid.events import subscriber

from ..events.resources import (
    ResourceCreated,
    ResourceChanged,
    ResourceDeleted,
    ResourceAssigned,
) 
from ..scheduler.notifications import add_notification
from ..bl.subscriptions import subscribe_resource


@subscriber(ResourceCreated)
def resource_created(event):
    subscribe_resource(event.request, event.obj.resource)
    add_notification(event.descr, event.obj.resource_id)


@subscriber(ResourceChanged)
def resource_changed(event):
    add_notification(event.descr, event.obj.resource_id)


@subscriber(ResourceDeleted)
def resource_deleted(event):
    add_notification(event.descr, event.obj.id)


@subscriber(ResourceAssigned)
def resource_assigned(event):
    add_notification(event.descr, event.obj.id)
