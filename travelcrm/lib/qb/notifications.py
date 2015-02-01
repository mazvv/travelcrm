# -*coding: utf-8-*-

from . import ResourcesQueryBuilder

from ...models.resource import Resource
from ...models.notification import Notification
from ...models.employee import Employee


class NotificationsQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(NotificationsQueryBuilder, self).__init__(context)
        self._fields = {
            'id': Notification.id,
            '_id': Notification.id,
            'title': Notification.title,
            'descr': Notification.descr,
            'created': Notification.created,
        }
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = self.query.join(Notification, Resource.notification)
        super(NotificationsQueryBuilder, self).build_query()

    def filter_employee(self, employee):
        assert isinstance(employee, Employee), u'Employee expected'
        self.query = (
            self.query
            .join(Employee, Notification.employees)
            .filter(Employee.id == employee.id)
        )
