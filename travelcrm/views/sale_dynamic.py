# -*-coding: utf-8-*-

import logging
from datetime import date, timedelta

import colander
from pygal import Line
from pygal.style import LightColorizedStyle
from pyramid.view import view_config, view_defaults
from pyramid.response import Response

from ..lib.qb.sale_dynamic import SaleDynamicQueryBuilder
from ..forms.sale_dynamic import (
    SettingsSchema, 
    SalesDynamicsSchema
)
from ..lib.utils.resources_utils import get_resource_type_by_resource
from ..lib.utils.common_utils import translate as _
from ..lib.utils.common_utils import serialize


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.sale_dynamic.SaleDynamicResource',
)
class SaleDynamicView(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/sales_dynamics/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        xhr='True',
        request_method='POST',
        permission='view'
    )
    def list(self):
        schema = SalesDynamicsSchema().bind(request=self.request)
        controls = schema.deserialize(self.request.params)
        qb = SaleDynamicQueryBuilder(self.context)
        date_start = date.today() - timedelta(controls.get('days'))
        date_end = date.today()
        qb.filter_paid(date_start, date_end)
        data = {}
        delta = date_end - date_start
        for i in range(delta.days + 1):
            data[date_start + timedelta(days=i)] = 0
        for item in qb.get_query():
            data[item.date] = item.base_sum
        data = [(d, val) for d, val in data.items()]
        data.sort(key=lambda item: item[0])

        chart = Line(
            width=595,
            height=267,
            show_legend=False,
            dots_size=2,
            fill=True,
            margin=3,
            no_data_text=_('No data to display'),
            style=LightColorizedStyle
        )
        x_data = []
        y_data = []
        for d, val in data:
            x_data.append(serialize(d))
            y_data.append(float(val))
        chart.x_labels = x_data
        chart.add(_('amount'), y_data)
        response = Response(body=chart.render(), content_type='image/svg+xml')
        return response

    @view_config(
        name='settings',
        request_method='GET',
        renderer='travelcrm:templates/sales_dynamics/settings.mak',
        permission='settings',
    )
    def settings(self):
        rt = get_resource_type_by_resource(self.context)
        return {
            'title': _(u'Settings'),
            'rt': rt,
        }

    @view_config(
        name='settings',
        request_method='POST',
        renderer='json',
        permission='settings',
    )
    def _settings(self):
        schema = SettingsSchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params)
            rt = get_resource_type_by_resource(self.context)
            rt.settings = {'column_index': controls.get('column_index')}
            return {'success_message': _(u'Saved')}
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }
