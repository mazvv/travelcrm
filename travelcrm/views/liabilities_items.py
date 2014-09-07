# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.resource import Resource
from ..models.liability_item import LiabilityItem
from ..lib.qb.liabilities_items import LiabilitiesItemsQueryBuilder
from ..lib.utils.common_utils import translate as _
from ..lib.utils.resources_utils import get_resource_class
from ..lib.bl.touroperators import get_calculation

from ..forms.liabilities_items import LiabilityItemSchema


log = logging.getLogger(__name__)


class LiabilityItems(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.liabilities_items.LiabilitiesItems',
        request_method='GET',
        renderer='travelcrm:templates/liabilities_items/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.liabilities_items.LiabilitiesItems',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def _list(self):
        qb = LiabilitiesItemsQueryBuilder(self.context)
        qb.search_simple(
            self.request.params.get('q')
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
        context='..resources.liabilities_items.LiabilitiesItems',
        request_method='GET',
        renderer='travelcrm:templates/liabilities_items/form.mak',
        permission='add'
    )
    def add(self):
        return {
            'title': _(u'Add Liability Item'),
        }

    @view_config(
        name='add',
        context='..resources.liabilities_items.LiabilitiesItems',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        schema = LiabilityItemSchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params)
            liability_item = LiabilityItem(
                service_id=controls.get('service_id'),
                touroperator_id=controls.get('touroperator_id'),
                currency_id=controls.get('currency_id'),
                price=controls.get('price'),
                resource=self.context.create_resource()
            )
            DBSession.add(liability_item)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': liability_item.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='autoload',
        context='..resources.liabilities_items.LiabilitiesItems',
        request_method='GET',
        renderer='travelcrm:templates/liabilities_items/autoload.mak',
        permission='add'
    )
    def autoload(self):
        return {
            'title': _(u'Autoload Liabilities Items'),
            'resource_id': self.request.params.get('resource_id'),
        }

    @view_config(
        name='autoload',
        context='..resources.liabilities_items.LiabilitiesItems',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _autoload(self):
        resource_id = self.request.params.get('resource_id')
        resource = Resource.get(resource_id)
        source_cls = get_resource_class(resource.resource_type.name)
        factory = source_cls.get_liability_factory()
        services_info = factory.services_info(resource_id)
        liabilities_items = []
        for item in services_info:
            supplier_price = get_calculation(
                item.touroperator_id,
                factory.get_source_date(resource_id),
                item.id,
                item.price,
                item.currency_id
            )
            liabilities_items.append(
                LiabilityItem(
                    service_id=item.id,
                    touroperator_id=item.touroperator_id,
                    currency_id=item.currency_id,
                    price=supplier_price,
                    resource=self.context.create_resource()
                )
            )
        DBSession.add_all(liabilities_items)
        DBSession.flush()
        return {
            'success_message': _(u'Saved'),
            'response': ','.join([str(item.id) for item in liabilities_items])
        }

    @view_config(
        name='edit',
        context='..resources.liabilities_items.LiabilitiesItems',
        request_method='GET',
        renderer='travelcrm:templates/liabilities_items/form.mak',
        permission='edit'
    )
    def edit(self):
        liability_item = LiabilityItem.get(self.request.params.get('id'))
        return {
            'item': liability_item,
            'title': _(u'Edit Liability Item'),
        }

    @view_config(
        name='edit',
        context='..resources.liabilities_items.LiabilitiesItems',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        schema = LiabilityItemSchema().bind(request=self.request)
        service_item = LiabilityItem.get(
            self.request.params.get('id')
        )
        try:
            controls = schema.deserialize(self.request.params)
            service_item.service_id = controls.get('service_id')
            service_item.touroperator_id = controls.get('touroperator_id')
            service_item.currency_id = controls.get('currency_id')
            service_item.price = controls.get('price')
            return {
                'success_message': _(u'Saved'),
                'response': service_item.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='copy',
        context='..resources.liabilities_items.LiabilitiesItems',
        request_method='GET',
        renderer='travelcrm:templates/liabilities_items/form.mak',
        permission='add'
    )
    def copy(self):
        liability_item = LiabilityItem.get(self.request.params.get('id'))
        return {
            'item': liability_item,
            'title': _(u"Copy Liability Item")
        }

    @view_config(
        name='copy',
        context='..resources.liabilities_items.LiabilitiesItems',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _copy(self):
        return self._add()

    @view_config(
        name='delete',
        context='..resources.liabilities_items.LiabilitiesItems',
        request_method='GET',
        renderer='travelcrm:templates/liabilities_items/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Liabilities Items'),
            'id': self.request.params.get('id')
        }

    @view_config(
        name='delete',
        context='..resources.liabilities_items.LiabilitiesItems',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        errors = 0
        for id in self.request.params.getall('id'):
            item = LiabilityItem.get(id)
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
