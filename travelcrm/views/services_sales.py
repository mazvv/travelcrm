# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.service_sale import ServiceSale
from ..models.service_item import ServiceItem
from ..lib.qb.services_sales import ServicesSalesQueryBuilder

from ..lib.utils.common_utils import translate as _
from ..forms.services_sales import ServiceSaleSchema


log = logging.getLogger(__name__)


class ServicesSales(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.services_sales.ServicesSales',
        request_method='GET',
        renderer='travelcrm:templates/services_sales/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.services_sales.ServicesSales',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        qb = ServicesSalesQueryBuilder(self.context)
        qb.search_simple(
            self.request.params.get('q'),
        )
        qb.advanced_search(
            updated_from=self.request.params.get('updated_from'),
            updated_to=self.request.params.get('updated_to'),
            modifier_id=self.request.params.get('modifier_id'),
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
        context='..resources.services_sales.ServicesSales',
        request_method='GET',
        renderer='travelcrm:templates/services_sales/form.mak',
        permission='add'
    )
    def add(self):
        return {
            'title': _(u'Add Service Sale'),
        }

    @view_config(
        name='add',
        context='..resources.services_sales.ServicesSales',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        schema = ServiceSaleSchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params.mixed())
            service_sale = ServiceSale(
                deal_date=controls.get('deal_date'),
                advsource_id=controls.get('advsource_id'),
                customer_id=controls.get('customer_id'),
                resource=self.context.create_resource()
            )
            for id in controls.get('service_item_id'):
                service_item = ServiceItem.get(id)
                service_sale.services_items.append(service_item)
            DBSession.add(service_sale)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': service_sale.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.services_sales.ServicesSales',
        request_method='GET',
        renderer='travelcrm:templates/services_sales/form.mak',
        permission='edit'
    )
    def edit(self):
        sale_service = ServiceSale.get(self.request.params.get('id'))
        return {
            'item': sale_service,
            'title': _(u'Edit Service Sale'),
        }

    @view_config(
        name='edit',
        context='..resources.services_sales.ServicesSales',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        schema = ServiceSaleSchema().bind(request=self.request)
        service_sale = ServiceSale.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params.mixed())
            service_sale.deal_date = controls.get('deal_date')
            service_sale.advsource_id = controls.get('advsource_id')
            service_sale.customer_id = controls.get('customer_id')
            service_sale.services_items = []
            for id in controls.get('service_item_id', []):
                service_item = ServiceItem.get(id)
                service_sale.services_items.append(service_item)
            return {
                'success_message': _(u'Saved'),
                'response': service_sale.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='copy',
        context='..resources.services_sales.ServicesSales',
        request_method='GET',
        renderer='travelcrm:templates/services_sales/form.mak',
        permission='add'
    )
    def copy(self):
        service_sale = ServiceSale.get(self.request.params.get('id'))
        return {
            'item': service_sale,
            'title': _(u"Copy Service Sale")
        }

    @view_config(
        name='copy',
        context='..resources.services_sales.ServicesSales',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _copy(self):
        return self._add()

    @view_config(
        name='delete',
        context='..resources.services_sales.ServicesSales',
        request_method='GET',
        renderer='travelcrm:templates/services_sales/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'id': self.request.params.get('id')
        }

    @view_config(
        name='delete',
        context='..resources.services_sales.ServicesSales',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        for id in self.request.params.getall('id'):
            service_sale = ServiceSale.get(id)
            if service_sale:
                DBSession.delete(service_sale)
        return {'success_message': _(u'Deleted')}
