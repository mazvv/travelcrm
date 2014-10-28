# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.calculation import Calculation
from ..lib.bl.calculations import (
    get_resource_calculations,
    get_resource_services_items,
    get_calculation_date,
    get_bound_resource_by_calculation_id,
)
from ..lib.bl.currencies_rates import currency_base_exchange
from ..lib.bl.commissions import get_commission
from ..lib.qb.calculations import CalculationsQueryBuilder
from ..lib.utils.common_utils import translate as _

from ..forms.calculations import CalculationSchema


log = logging.getLogger(__name__)


class Calculations(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.calculations.Calculations',
        request_method='GET',
        renderer='travelcrm:templates/calculations/index.mak',
        permission='view'
    )
    def index(self):
        resource_id = self.request.params.get('resource_id')
        return {
            'resource_id': resource_id,
        }

    @view_config(
        name='list',
        context='..resources.calculations.Calculations',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def _list(self):
        qb = CalculationsQueryBuilder(self.context)
        qb.search_simple(
            self.request.params.get('q')
        )
        resource_id = self.request.params.get('resource_id')
        calculations = get_resource_calculations(resource_id)
        ids = [None, ] + [calculation.id for calculation in calculations]
        qb.filter_id(ids)
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
        name='view',
        context='..resources.calculations.Calculations',
        request_method='GET',
        renderer='travelcrm:templates/calculations/form.mak',
        permission='view'
    )
    def view(self):
        result = self.edit()
        result.update({
            'title': _(u"View Calculation"),
            'readonly': True,
        })
        return result

    @view_config(
        name='autoload',
        context='..resources.calculations.Calculations',
        request_method='GET',
        renderer='travelcrm:templates/calculations/autoload.mak',
        permission='autoload'
    )
    def autoload(self):
        return {
            'title': _(u'Calculation Autoload'),
        }

    @view_config(
        name='autoload',
        context='..resources.calculations.Calculations',
        request_method='POST',
        renderer='json',
        permission='autoload'
    )
    def _autoload(self):
        resource_id = self.request.params.get('resource_id')
        services_items = get_resource_services_items(resource_id)
        calculation_date = get_calculation_date(resource_id)
        for service_item in services_items:
            commission_sum = get_commission(
                service_item.price,
                service_item.touroperator_id,
                service_item.service_id,
                service_item.currency_id,
                calculation_date
            )
            price = service_item.price - commission_sum
            calculation = Calculation(
                currency_id=service_item.currency_id,
                price=price,
                service_item=service_item,
                base_price=currency_base_exchange(
                    price,
                    service_item.currency_id,
                    calculation_date,
                ),
                resource=self.context.create_resource(),
            )
            DBSession.add(calculation)
        DBSession.flush()
        return {
            'success_message': _(u'Saved'),
        }

    @view_config(
        name='edit',
        context='..resources.calculations.Calculations',
        request_method='GET',
        renderer='travelcrm:templates/calculations/form.mak',
        permission='edit'
    )
    def edit(self):
        calculation = Calculation.get(self.request.params.get('id'))
        return {
            'item': calculation,
            'title': _(u'Edit Calculation'),
        }

    @view_config(
        name='edit',
        context='..resources.calculations.Calculations',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        schema = CalculationSchema().bind(request=self.request)
        calculation = Calculation.get(
            self.request.params.get('id')
        )
        try:
            controls = schema.deserialize(self.request.params)
            resource = get_bound_resource_by_calculation_id(calculation.id)
            calculation.price = controls.get('price')
            calculation.currency_id = controls.get('currency_id')
            calculation.base_price = currency_base_exchange(
                calculation.price,
                calculation.currency_id,
                get_calculation_date(resource.id),
            )
            return {
                'success_message': _(u'Saved'),
                'response': calculation.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='delete',
        context='..resources.calculations.Calculations',
        request_method='GET',
        renderer='travelcrm:templates/calculations/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Calculations'),
            'id': self.request.params.get('id')
        }

    @view_config(
        name='delete',
        context='..resources.calculations.Calculations',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        errors = 0
        for id in self.request.params.getall('id'):
            item = Calculation.get(id)
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
