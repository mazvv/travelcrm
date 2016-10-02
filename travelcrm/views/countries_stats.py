# -*-coding: utf-8-*-

import logging
from pyramid.view import view_config, view_defaults

from ..resources.countries_stats import CountriesStatsResource
from ..forms.countries_stats import (
    CountriesStatsSearchForm,
    CountriesStatsSettingsForm
)
from . import BaseView
from ..lib.utils.resources_utils import get_resource_type_by_resource
from ..lib.utils.common_utils import translate as _


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.countries_stats.CountriesStatsResource',
)
class CountriesStatsView(BaseView):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/countries_stats/index.mako',
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
        form = CountriesStatsSearchForm(
            self.request, CountriesStatsResource(self.request)
        )
        form.validate()
        qb = form.submit()
        data = {}
        for row in qb.query:
            data[row.iso_code] = row.quan
        return data

    @view_config(
        name='settings',
        request_method='GET',
        renderer='travelcrm:templates/countries_stats/settings.mako',
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
        form = CountriesStatsSettingsForm(self.request)
        if form.validate():
            form.submit()
            return {'success_message': _(u'Saved')}
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }
