# -*coding: utf-8-*-

from . import ResourcesQueryBuilder

from ...models.resource import Resource
from ...models.notification import (
    Notification,
    EmployeeNotification
)
from ...models.employee import Employee


class NotificationQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(NotificationQueryBuilder, self).__init__(context)
        self._fields = {
            'id': Notification.id,
            '_id': Notification.id,
            'title': Notification.title,
            'status': EmployeeNotification.status,
            'descr': Notification.descr,
            'created': Notification.created,
        }
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = (
            self.query
            .join(Notification, Resource.notification)
            .join(
                EmployeeNotification,
                Notification.id == EmployeeNotification.notification_id
            )
        )
        super(NotificationQueryBuilder, self).build_query()

    def advanced_search(self, **kwargs):
        super(NotificationQueryBuilder, self).advanced_search(**kwargs)
        if 'status' in kwargs:
            self._filter_status(kwargs.get('status'))

    def filter_employee(self, employee):
        assert isinstance(employee, Employee), u'Employee expected'
        self.query = (
            self.query
            .join(Employee, Notification.employees)
            .filter(Employee.id == employee.id)
        )

    def _filter_status(self, status):
        if status:
            self.query = self.query.filter(
                EmployeeNotification.status == status
            )
