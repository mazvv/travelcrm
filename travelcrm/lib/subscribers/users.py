#-*-coding:utf-8-*-

from pyramid.events import subscriber

from ..events.users import (
    UserCreated,
    UserPasswdRecovery,
) 
from ..scheduler.users import (
    schedule_user_password_recovery,
    schedule_user_created
)


@subscriber(UserPasswdRecovery)
def recovery_password(event):
    schedule_user_password_recovery(event.request, event.user.id)


@subscriber(UserCreated)
def user_created(event):
    schedule_user_created(event.request, event.user.id)
