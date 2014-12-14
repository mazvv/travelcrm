# -*coding: utf-8-*-

from . import ResourcesQueryBuilder

from ...models.resource import Resource
from ...models.notification import Notification
from ...models.employee import Employee


class NotificationsQueryBuilder(ResourcesQueryBuilder):

    _fields = {
        'id': Notification.id,
        '_id': Notification.id,
        'title': Notification.title,
        'descr': Notification.descr,
        'created': Notification.created,
    }

    def __init__(self, context):
        super(NotificationsQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = self.query.join(Notification, Resource.notification)
        self.query = self.query.add_columns(*fields)

    def filter_employee(self, employee):
        assert isinstance(employee, Employee), u'Employee expected'
        self.query = (
            self.query
            .join(Employee, Notification.employees)
            .filter(Employee.id == employee.id)
        )
