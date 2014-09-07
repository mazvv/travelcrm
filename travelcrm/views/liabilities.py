# -*-coding: utf-8-*-

import logging

import colander
from babel.numbers import format_decimal

from pyramid.view import view_config
from pyramid.httpexceptions import HTTPFound

from ..models import DBSession
from ..models.liability import Liability
from ..models.liability_item import LiabilityItem
from ..models.resource import Resource
from ..models.account import Account
from ..lib.qb import query_serialize
from ..lib.qb.liabilities import LiabilitiesQueryBuilder
from ..lib.utils.common_utils import translate as _

from ..forms.liabilities import LiabilitySchema

from ..lib.utils.resources_utils import get_resource_class
from ..lib.utils.common_utils import get_locale_name
from ..lib.bl.liabilities import (
    query_resource_data,
)

log = logging.getLogger(__name__)


class Liabilities(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.liabilities.Liabilities',
        request_method='GET',
        renderer='travelcrm:templates/liabilities/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.liabilities.Liabilities',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        qb = LiabilitiesQueryBuilder(self.context)
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
        context='..resources.liabilities.Liabilities',
        request_method='GET',
        renderer='travelcrm:templates/liabilities/form.mak',
        permission='add'
    )
    def add(self):
        resource_id = self.request.params.get('resource_id')
        resource = Resource.get(resource_id)
        source_cls = get_resource_class(resource.resource_type.name)
        factory = source_cls.get_liability_factory()
        liability = factory.get_liability(resource_id)
        if liability:
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'edit', query={'id': resource.id}
                ),
            )
        return {
            'title': _(u'Add Liability'),
            'resource_id': resource_id,
            'date': factory.get_source_date(resource.id)
        }

    @view_config(
        name='add',
        context='..resources.liabilities.Liabilities',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        schema = LiabilitySchema().bind(request=self.request)

        try:
            controls = schema.deserialize(self.request.params.mixed())
            resource_id = controls.get('resource_id')
            resource = Resource.get(resource_id)
            source_cls = get_resource_class(resource.resource_type.name)
            factory = source_cls.get_liability_factory()
            liability = Liability(
                date=controls.get('date'),
                resource=self.context.create_resource()
            )
            for id in controls.get('liability_item_id'):
                item = LiabilityItem.get(id)
                liability.liabilities_items.append(item)
            factory.bind_liability(resource_id, liability)
            return {
                'success_message': _(u'Saved'),
                'response': None
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.liabilities.Liabilities',
        request_method='GET',
        renderer='travelcrm:templates/liabilities/form.mak',
        permission='edit'
    )
    def edit(self):
        liability = Liability.get(self.request.params.get('id'))
        bound_resource = (
            query_resource_data()
            .filter(Liability.id == liability.id)
            .first()
        )
        structure_id = liability.resource.owner_structure.id
        return {
            'item': liability,
            'structure_id': structure_id,
            'resource_id': bound_resource.resource_id,
            'title': _(u'Edit Liability')
        }

    @view_config(
        name='edit',
        context='..resources.liabilities.Liabilities',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        schema = LiabilityEditSchema().bind(request=self.request)
        liability = Liability.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params)
            liability.date = controls.get('date')
            liability.account_id = controls.get('account_id')
            return {
                'success_message': _(u'Saved'),
                'response': liability.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='delete',
        context='..resources.liabilities.Liabilities',
        request_method='GET',
        renderer='travelcrm:templates/liabilities/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Liabilities'),
            'rid': self.request.params.get('rid')
        }

    @view_config(
        name='delete',
        context='..resources.liabilities.Liabilities',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        errors = 0
        for id in self.request.params.getall('id'):
            item = Liability.get(id)
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

    @view_config(
        name='print',
        context='..resources.liabilities.Liabilities',
        request_method='GET',
        renderer='travelcrm:templates/liabilities/print.mak',
        permission='view',
    )
    def print_liability(self):
        liability = Liability.get(self.request.params.get('id'))
        factory = get_factory_by_liability_id(liability.id)
        bound_resource = (
            query_resource_data()
            .filter(Liability.id == liability.id)
            .first()
        )
        payment_query = query_liability_payments(self.request.params.get('id'))
        payment_sum = sum(row.sum for row in payment_query)
        return {
            'liability': liability,
            'factory': factory,
            'resource_id': bound_resource.resource_id,
            'payment_sum': payment_sum,
        }

    @view_config(
        name='liability_sum',
        context='..resources.liabilities.Liabilities',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def liability_sum(self):
        schema = LiabilitySumSchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params)
            resource_id = controls.get('resource_id')
            account_id = controls.get('account_id')
            date = controls.get('date')
            resource = Resource.get(resource_id)
            source_cls = get_resource_class(resource.resource_type.name)
            factory = source_cls.get_liability_factory()
            account = Account.get(account_id)
            return {
                'liability_sum': str(
                    factory.get_sum_by_resource_id(
                        resource.id, account.currency_id, date
                    )
                ),
                'currency': account.currency.iso_code
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='info',
        context='..resources.liabilities.Liabilities',
        request_method='GET',
        renderer='travelcrm:templates/liabilities/info.mak',
        permission='view'
    )
    def info(self):
        liability = Liability.get(self.request.params.get('id'))
        return {
            'title': _(u'Liability Info'),
            'currency': liability.account.currency.iso_code,
            'id': liability.id
        }

    @view_config(
        name='services_info',
        context='..resources.liabilities.Liabilities',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def _services_info(self):
        liability = Liability.get(self.request.params.get('id'))
        bound_resource = (
            query_resource_data()
            .filter(Liability.id == liability.id)
            .first()
        )
        resource = Resource.get(bound_resource.resource_id)
        source_cls = get_resource_class(resource.resource_type.name)
        factory = source_cls.get_liability_factory()
        query = factory.services_info(
            bound_resource.resource_id, liability.account.currency.id
        )
        total_cnt = sum(row.cnt for row in query)
        total_sum = sum(row.price for row in query)
        return {
            'rows': query_serialize(query),
            'footer': [{
                'name': _(u'total'),
                'cnt': total_cnt,

                'price': format_decimal(total_sum, locale=get_locale_name())
            }]
        }

    @view_config(
        name='accounts_items_info',
        context='..resources.liabilities.Liabilities',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def _accounts_items_info(self):
        liability = Liability.get(self.request.params.get('id'))
        bound_resource = (
            query_resource_data()
            .filter(Liability.id == liability.id)
            .first()
        )
        resource = Resource.get(bound_resource.resource_id)
        source_cls = get_resource_class(resource.resource_type.name)
        factory = source_cls.get_liability_factory()
        query = factory.accounts_items_info(
            bound_resource.resource_id, liability.account.currency.id
        )
        total_cnt = sum(row.cnt for row in query)
        total_sum = sum(row.price for row in query)
        return {
            'rows': query_serialize(query),
            'footer': [{
                'name': _(u'total'),
                'cnt': total_cnt,
                'price': format_decimal(total_sum, locale=get_locale_name()),
            }]
        }

    @view_config(
        name='payments_info',
        context='..resources.liabilities.Liabilities',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def _payments_info(self):
        query = query_liability_payments(self.request.params.get('id'))
        total_sum = sum(row.sum for row in query)
        return {
            'rows': query_serialize(query),
            'footer': [{
                'date': _(u'total'),
                'sum': format_decimal(total_sum, locale=get_locale_name())
            }]
        }

    @view_config(
        name='transactions_info',
        context='..resources.liabilities.Liabilities',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def _transactions_info(self):
        query = query_liability_payments_transactions(
            self.request.params.get('id')
        )
        total_sum = sum(row.sum for row in query)
        return {
            'rows': query_serialize(query),
            'footer': [{
                'date': _(u'total'),
                'sum': format_decimal(total_sum, locale=get_locale_name())
            }]
        }
