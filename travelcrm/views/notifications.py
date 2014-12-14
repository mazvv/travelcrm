# -*-coding: utf-8-*-

import logging

from pyramid.view import view_config

from ..models.notification import Notification
from ..lib.qb.notifications import NotificationsQueryBuilder
from ..lib.utils.common_utils import translate as _
from ..lib.utils.security_utils import get_auth_employee


log = logging.getLogger(__name__)


class Notifications(object):

    def __init__(self, context, request):
        self.employee = get_auth_employee(request)
        self.context = context
        self.request = request

    @view_config(
        context='..resources.notifications.Notifications',
        request_method='GET',
        renderer='travelcrm:templates/notifications/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.notifications.Notifications',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def _list(self):
        qb = NotificationsQueryBuilder(self.context)
        qb.filter_employee(self.employee)
        qb.sort_query(
            self.request.params.get('sort'),
            self.request.params.get('order', 'asc')
        )
        qb.page_query(
            int(self.request.params.get('rows')),
            int(self.request.params.get('page'))
        )
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized()
        }

    @view_config(
        name='counter',
        context='..resources.notifications.Notifications',
        request_method='GET',
        renderer='json',
        permission='view'
    )
    def counter(self):
        return {
            'count': self.employee.notifications.count(),
        }

    @view_config(
        name='details',
        context='..resources.notifications.Notifications',
        request_method='GET',
        renderer='travelcrm:templates/notifications/details.mak',
        permission='view'
    )
    def details(self):
        notification = Notification.get(self.request.params.get('id'))
        return {
            'item': notification,
        }

    @view_config(
        name='delete',
        context='..resources.notifications.Notifications',
        request_method='GET',
        renderer='travelcrm:templates/notifications/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Notifications'),
            'id': self.request.params.get('id')
        }

    @view_config(
        name='delete',
        context='..resources.notifications.Notifications',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        for id in self.request.params.getall('id'):
            item = Notification.get(id)
            item.employees.remove(self.employee)
        return {'success_message': _(u'Deleted')}
