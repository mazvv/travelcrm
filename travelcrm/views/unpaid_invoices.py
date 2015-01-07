# -*-coding: utf-8-*-

import logging

import colander
from pyramid.view import view_config
from ..lib.qb.unpaid_invoices import UnpaidInvoicesQueryBuilder
from ..forms.unpaid_invoices import SettingsSchema
from ..lib.utils.resources_utils import get_resource_type_by_resource
from ..lib.utils.common_utils import translate as _


log = logging.getLogger(__name__)


class UnpaidInvoices(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.unpaid_invoices.UnpaidInvoices',
        request_method='GET',
        renderer='travelcrm:templates/unpaid_invoices/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.unpaid_invoices.UnpaidInvoices',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        qb = UnpaidInvoicesQueryBuilder(self.context)
        qb.filter_unpaid()
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
        name='settings',
        context='..resources.unpaid_invoices.UnpaidInvoices',
        request_method='GET',
        renderer='travelcrm:templates/unpaid_invoices/settings.mak',
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
        context='..resources.unpaid_invoices.UnpaidInvoices',
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
