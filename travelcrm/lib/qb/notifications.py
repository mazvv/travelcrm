# -*coding: utf-8-*-

from . import ResourcesQueryBuilder

from ...lib.helpers import text
from ...models.resource import Resource
from ...models.notification import (
    Notification,
    EmployeeNotification
)


class _TitleSerializer():
    CHARACTERS_LIMIT = 28

    def __call__(self, name, row):
        return text.truncate(row.title, self.CHARACTERS_LIMIT)


class NotificationsQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(NotificationsQueryBuilder, self).__init__(context)
        self._fields = {
            'id': Notification.id,
            '_id': Notification.id,
            'status': EmployeeNotification.status,
            'title': Notification.descr,
            'descr': Notification.descr,
            'created': Notification.created,
        }
        self.build_query()
        self._serializers = {
            'title': _TitleSerializer()
        }

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
        super(NotificationsQueryBuilder, self).build_query()

    def advanced_search(self, **kwargs):
        super(NotificationsQueryBuilder, self).advanced_search(**kwargs)
        if 'status' in kwargs:
            self._filter_status(kwargs.get('status'))
        if 'employee_id' in kwargs:
            self._filter_employee_id(kwargs.get('employee_id'))

    def _filter_employee_id(self, employee_id):
        if employee_id:
            self.query = self.query.filter(
                EmployeeNotification.employee_id == employee_id
            )

    def _filter_status(self, status):
        if status:
            self.query = self.query.filter(
                EmployeeNotification.status == status
            )
