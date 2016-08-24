# -*-coding: utf-8-*-

import logging
from datetime import datetime, timedelta
from pyramid.view import view_config, view_defaults

from ..resources.orders import OrdersResource
from ..forms.orders_stats import (
    OrdersStatsSearchForm,
    OrdersStatsSettingsForm
)
from . import BaseView
from ..lib.bl.charts import get_settings
from ..lib.utils.resources_utils import get_resource_type_by_resource
from ..lib.utils.common_utils import serialize
from ..lib.utils.common_utils import translate as _


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.orders_stats.OrdersStatsResource',
)
class OrdersStatsView(BaseView):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/orders_stats/index.mako',
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
    def list(self):
        form = OrdersStatsSearchForm(self.request, OrdersResource(self.request))
        form.validate()
        qb = form.submit()
        labels = [
            datetime.today().date() - timedelta(days=x)
            for x in range(0, form.get_period())
        ]
        labels.reverse()
        data = [0] * len(labels)
        for row in qb.query:
            index = labels.index(row.deal_date)
            data[index] = row.quan
        labels = map(serialize, labels)
        dataset = {'data': data}
        dataset.update(get_settings())
        return {
            'labels': labels,
            'datasets': [dataset]
        }

    @view_config(
        name='settings',
        request_method='GET',
        renderer='travelcrm:templates/orders_stats/settings.mako',
        permission='settings',
    )
    def settings(self):
        rt = get_resource_type_by_resource(self.context)
        return {
            'title': self._get_title(_(u'Settings')),
            'rt': rt,
        }

    @view_config(
        name='settings',
        request_method='POST',
        renderer='json',
        permission='settings',
    )
    def _settings(self):
        form = OrdersStatsSettingsForm(self.request)
        if form.validate():
            form.submit()
            return {'success_message': _(u'Saved')}
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }
