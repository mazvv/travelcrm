# -*-coding: utf-8-*-

import logging

from pyramid.view import view_config, view_defaults

from . import BaseView
from ..models.notification import Notification
from ..lib.bl.notifications import close_notification
from ..lib.utils.common_utils import translate as _
from ..lib.utils.security_utils import get_auth_employee
from ..lib.utils.resources_utils import get_resource_class

from ..forms.notifications import NotificationSearchForm


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.notifications.NotificationsResource',
)
class NotificationsView(BaseView):

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/notifications/index.mako',
        permission='view'
    )
    def index(self):
        return {
            'title': self._get_title(),
        }

    @view_config(
        name='list',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def _list(self):
        form = NotificationSearchForm(self.request, self.context)
        form.validate()
        qb = form.submit()
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized()
        }

    @view_config(
        name='counter',
        request_method='GET',
        renderer='sse',
        permission='view'
    )
    def counter(self):
        form = NotificationSearchForm(self.request, self.context)
        form.validate()
        qb = form.submit()
        qb.advanced_search(**{'status': 'new'})
        return {
            'count': qb.query.count(),
        }


    @view_config(
        name='details',
        request_method='GET',
        renderer='travelcrm:templates/notifications/details.mako',
        permission='view'
    )
    def details(self):
        notification = Notification.get(self.request.params.get('id'))
        notification_resource = None
        if notification.notification_resource:
            resource_cls = get_resource_class(
                notification.notification_resource.resource_type.name
            )
            notification_resource = resource_cls(self.request)
        return {
            'item': notification,
            'notification_resource': notification_resource,
        }

    @view_config(
        name='close',
        request_method='GET',
        renderer='travelcrm:templates/notifications/close.mako',
        permission='close'
    )
    def close(self):
        return {
            'title': _(u'Close Notification'),
            'id': self.request.params.get('id')
        }

    @view_config(
        name='close',
        request_method='POST',
        renderer='json',
        permission='close'
    )
    def _close(self):
        employee = get_auth_employee(self.request)
        for id in self.request.params.getall('id'):
            item = Notification.get(id)
            close_notification(employee, item)
        return {'success_message': _(u'Closed')}
