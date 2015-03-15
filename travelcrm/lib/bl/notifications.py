# -*coding: utf-8-*-

from ...models import DBSession
from ...models.employee import Employee
from ...models.notification import (
    Notification,
    EmployeeNotification,
)


def close_notification(employee, notification):
    assert isinstance(employee, Employee), u'Employee expected'
    assert isinstance(notification, Notification), u'Notification expected'
    employee_notification = (
        DBSession.query(EmployeeNotification)
        .filter(
            EmployeeNotification.employee_id == employee.id,
            EmployeeNotification.notification_id == notification.id
        )
        .first()
    )
    employee_notification.close()
