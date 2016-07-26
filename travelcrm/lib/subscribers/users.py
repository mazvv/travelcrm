#-*-coding:utf-8-*-

from pyramid.events import subscriber

from ...models.notification import Notification
from ...models.resource import Resource
from ...resources.notifications import NotificationsResource
from ..events.users import (
    UserCreated,
    UserEdited,
    UserPasswdRecovery,
) 
from ..scheduler.users import (
    schedule_user_password_recovery,
    schedule_user_created
)
from ..utils.security_utils import get_auth_employee
from ..utils.common_utils import translate as _
from ..bl.employees import get_employee_structure  


@subscriber(UserPasswdRecovery)
def recovery_password(event):
    schedule_user_password_recovery(event.request, event.user.id)


@subscriber(UserCreated)
def user_created(event):
    schedule_user_created(event.request, event.user.id)


@subscriber(UserEdited)
def changes_notify(event):
    employee = get_auth_employee(event.request)
    if (
        not employee 
        or not get_employee_structure(event.user.employee)
        or (employee.id and event.user.employee_id == employee.id)
    ):
        return
    notification = Notification(
        title=_(u'Your User profile was changed'),
        descr='',
        notification_resource=event.user.resource,
        resource=Resource(NotificationsResource, event.user.employee)
    )
    event.user.employee.notifications.append(notification)
