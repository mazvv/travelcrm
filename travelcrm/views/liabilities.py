# -*-coding: utf-8-*-

import logging

import colander

from pyramid.view import view_config
from pyramid.httpexceptions import HTTPFound

from ..models import DBSession
from ..models.liability import Liability
from ..models.liability_item import LiabilityItem
from ..models.resource import Resource
from ..lib.qb.liabilities import LiabilitiesQueryBuilder
from ..lib.utils.common_utils import translate as _

from ..forms.liabilities import (
    LiabilitySchema,
    LiabilityAddSchema,
)

from ..lib.utils.resources_utils import get_resource_class
from ..lib.bl.currencies_rates import query_convert_rates
from ..lib.utils.common_utils import money_cast
from ..lib.bl.liabilities import get_bound_resource_by_liability_id

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
        schema = LiabilityAddSchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params.mixed())
            resource_id = controls.get('resource_id')
            resource = Resource.get(resource_id)
            source_cls = get_resource_class(resource.resource_type.name)
            factory = source_cls.get_liability_factory()
            liability = Liability(
                date=controls.get('date'),
                descr=controls.get('description'),
                resource=self.context.create_resource()
            )
            for id in controls.get('liability_item_id'):
                item = LiabilityItem.get(id)
                liability.liabilities_items.append(item)
                base_liability_rate = (
                    query_convert_rates(item.currency_id, liability.date)
                    .scalar() or 1
                )
                item.base_price = money_cast(item.price * base_liability_rate)
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
        bound_resource = get_bound_resource_by_liability_id(
            liability.id
        )
        return {
            'item': liability,
            'resource_id': bound_resource.id,
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
        schema = LiabilitySchema().bind(request=self.request)
        liability = Liability.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params.mixed())
            liability.date = controls.get('date')
            liability.descr = controls.get('description')
            liability.liabilities_items = []
            for id in controls.get('liability_item_id'):
                item = LiabilityItem.get(id)
                base_liability_rate = (
                    query_convert_rates(item.currency_id, liability.date)
                    .scalar() or 1
                )
                item.base_price = money_cast(item.price * base_liability_rate)
                liability.liabilities_items.append(item)
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
