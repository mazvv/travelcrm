# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.currency_rate import CurrencyRate
from ..lib.qb.currencies_rates import CurrenciesRatesQueryBuilder
from ..lib.utils.common_utils import translate as _

from ..forms.currencies_rates import CurrencyRateSchema


log = logging.getLogger(__name__)


class CurrenciesRates(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.currencies_rates.CurrenciesRates',
        request_method='GET',
        renderer='travelcrm:templates/currencies_rates/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.currencies_rates.CurrenciesRates',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        qb = CurrenciesRatesQueryBuilder(self.context)
        qb.search_simple(
            self.request.params.get('q'),
        )
        qb.advanced_search(
            **self.request.params.mixed()
        )
        id = self.request.params.get('id')
        if id:
            qb.filter_id(id.split(','))
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
        name='add',
        context='..resources.currencies_rates.CurrenciesRates',
        request_method='GET',
        renderer='travelcrm:templates/currencies_rates/form.mak',
        permission='add'
    )
    def add(self):
        return {'title': _(u'Add Currency Rate')}

    @view_config(
        name='add',
        context='..resources.currencies_rates.CurrenciesRates',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        schema = CurrencyRateSchema().bind(request=self.request)

        try:
            controls = schema.deserialize(self.request.params)
            currency_rate = CurrencyRate(
                currency_id=controls.get('currency_id'),
                rate=controls.get('rate'),
                date=controls.get('date'),
                resource=self.context.create_resource()
            )
            DBSession.add(currency_rate)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': currency_rate.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.currencies_rates.CurrenciesRates',
        request_method='GET',
        renderer='travelcrm:templates/currencies_rates/form.mak',
        permission='edit'
    )
    def edit(self):
        currency_rate = CurrencyRate.get(self.request.params.get('id'))
        return {'item': currency_rate, 'title': _(u'Edit Currency Rate')}

    @view_config(
        name='edit',
        context='..resources.currencies_rates.CurrenciesRates',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        schema = CurrencyRateSchema().bind(request=self.request)
        currency_rate = CurrencyRate.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params)
            currency_rate.currency_id = controls.get('currency_id')
            currency_rate.rate = controls.get('rate')
            currency_rate.date = controls.get('date')
            return {
                'success_message': _(u'Saved'),
                'response': currency_rate.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='copy',
        context='..resources.currencies_rates.CurrenciesRates',
        request_method='GET',
        renderer='travelcrm:templates/currencies_rates/form.mak',
        permission='add'
    )
    def copy(self):
        currency_rate = CurrencyRate.get(self.request.params.get('id'))
        return {
            'item': currency_rate,
            'title': _(u"Copy Rate")
        }

    @view_config(
        name='copy',
        context='..resources.currencies_rates.CurrenciesRates',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _copy(self):
        return self._add()

    @view_config(
        name='delete',
        context='..resources.currencies_rates.CurrenciesRates',
        request_method='GET',
        renderer='travelcrm:templates/currencies_rates/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Currencies Rates'),
            'rid': self.request.params.get('rid')
        }

    @view_config(
        name='delete',
        context='..resources.currencies_rates.CurrenciesRates',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        errors = 0
        for id in self.request.params.getall('id'):
            item = CurrencyRate.get(id)
            if item:
                DBSession.begin_nested()
                try:
                    DBSession.delete(item)
                    DBSession.commit()
                except:
                    errors += 1
                    DBSession.rollback()
        if errors > 0:
            return {
                'error_message': _(
                    u'Some objects could not be delete'
                ),
            }
        return {'success_message': _(u'Deleted')}
