# -*-coding: utf-8-*-

import logging

from pyramid.view import view_config, view_defaults

from ..models.notification import Notification
from ..lib.qb.notification import NotificationQueryBuilder
from ..lib.bl.notifications import close_notification
from ..lib.utils.common_utils import translate as _
from ..lib.utils.security_utils import get_auth_employee
from ..lib.utils.resources_utils import get_resource_class

from ..forms.notification import NotificationSearchForm


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.notification.NotificationResource',
)
class NotificationView(object):

    def __init__(self, context, request):
        self.employee = get_auth_employee(request)
        self.context = context
        self.request = request

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/notification/index.mak',
        permission='view'
    )
    def index(self):
        return {}

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
        renderer='json',
        permission='view'
    )
    def counter(self):
        qb = NotificationQueryBuilder(self.context)
        qb.filter_employee(self.employee)
        qb.advanced_search(status='new')
        return {
            'count': qb.query.count(),
        }

    @view_config(
        name='details',
        request_method='GET',
        renderer='travelcrm:templates/notification/details.mak',
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
        renderer='travelcrm:templates/notification/close.mak',
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
        for id in self.request.params.getall('id'):
            item = Notification.get(id)
            close_notification(self.employee, item)
        return {'success_message': _(u'Closed')}
